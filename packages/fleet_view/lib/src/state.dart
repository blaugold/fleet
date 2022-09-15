// ignore: implementation_imports
import 'package:fleet/src/transaction.dart';

Object? _currentTransaction;

/// Runs a [block] in a [transaction] and returns the result.
T withTransaction<T>(Object? transaction, T Function() block) {
  final previousTransaction = _currentTransaction;
  _currentTransaction = transaction;
  try {
    return block();
  } finally {
    _currentTransaction = previousTransaction;
  }
}

/// The reason why a state change is being applied.
enum SetStateReason {
  /// The state was changed by the user.
  change,

  /// The state is being restored to a previous value.
  revert,

  /// The state is being applied to rebuild dependent state.
  rebuild,
}

/// Function that set state to a provided value.
typedef StateSetter<T> = void Function(T, SetStateReason reason);

/// Function that needs to be used to update state that is managed by Fleet.
///
/// Callers do not need to update the state directly. Instead, this function
/// calls uses [stateSetter] to update the state before it returns.
void updateState<T>(
  T oldValue,
  T newValue,
  StateSetter<T> stateSetter,
) {
  if (oldValue == newValue) {
    return;
  }

  final change = _Change<T>(newValue, oldValue, stateSetter);

  // We immediately make the change observable.
  // This does not trigger any rebuilds. That happens later.
  change.apply();

  if (TransactionBinding.instance != null) {
    _recordChange(change);
  } else {
    // If transaction are not available (e.g. in tests), apply the change
    // immediately for rebuilding as well.
    // Transactions won't work in this case.
    change.applyForRebuild();
  }
}

final _pendingChangeSets = <_ChangeSet>[];

void _recordChange(_Change<void> change) {
  _ChangeSet changeSet;
  if (_pendingChangeSets.isEmpty) {
    changeSet = _startNewChangeSet();
  } else {
    changeSet = _pendingChangeSets.last;
    if (changeSet.transaction != _currentTransaction) {
      changeSet = _startNewChangeSet();
    }
  }

  changeSet.addChange(change);
}

_ChangeSet _startNewChangeSet() {
  final changeSet = _ChangeSet(_currentTransaction);
  _pendingChangeSets.add(changeSet);

  if (_pendingChangeSets.length == 1) {
    _isFirstChangeSet = true;
    TransactionBinding.instance!
        .scheduleTransaction(changeSet.transaction, _applyChangeSet);
  }

  return changeSet;
}

var _isFirstChangeSet = true;

void _applyChangeSet() {
  if (_isFirstChangeSet) {
    _isFirstChangeSet = false;

    if (_pendingChangeSets.length > 1) {
      _ChangeSet.revertAll(_pendingChangeSets);
    }
  }

  _pendingChangeSets.removeAt(0).applyForRebuild();

  if (_pendingChangeSets.isNotEmpty) {
    TransactionBinding.instance!.scheduleTransaction(
      _pendingChangeSets.first.transaction,
      _applyChangeSet,
    );
  }
}

class _Change<T> {
  _Change(this._newValue, this._oldValue, this._stateSetter);

  final T _newValue;
  final T _oldValue;
  final StateSetter<T> _stateSetter;

  void apply() => _stateSetter(_newValue, SetStateReason.change);

  void revert() {
    _stateSetter(_oldValue, SetStateReason.revert);
  }

  void applyForRebuild() {
    _stateSetter(_newValue, SetStateReason.rebuild);
  }
}

class _ChangeSet {
  _ChangeSet(this.transaction);

  static void revertAll(List<_ChangeSet> changeSets) {
    for (final changeSet in changeSets.reversed) {
      changeSet.revert();
    }
  }

  final Object? transaction;

  final List<_Change<void>> _changes = [];

  void addChange(_Change<void> change) {
    _changes.add(change);
  }

  void revert() {
    for (final change in _changes.reversed) {
      change.revert();
    }
  }

  void applyForRebuild() {
    for (final change in _changes) {
      change.applyForRebuild();
    }
  }
}
