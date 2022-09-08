// ignore_for_file: public_member_api_docs

import 'package:flutter/widgets.dart';

import 'transaction.dart';

class FleetWidget {
  const FleetWidget();
}

const fleetWidget = FleetWidget();

class _State {
  const _State();
}

const state = _State();

abstract class FleetWidgetBase {
  Widget build(BuildContext context);
}

abstract class StatelessFleetWidget extends StatelessWidget
    implements FleetWidgetBase {}

abstract class StatefulFleetWidget extends Widget implements FleetWidgetBase {
  const StatefulFleetWidget({super.key});

  Object createState(StatefulFleetElement element);

  StatefulFleetWidget withState(covariant Object state);

  Object get _state;

  @override
  Element createElement() => StatefulFleetElement(this);
}

class StatefulFleetElement extends ComponentElement {
  StatefulFleetElement(super.widget);

  @override
  StatefulFleetWidget get widget => super.widget as StatefulFleetWidget;

  StatefulFleetWidget? statefulWidget;

  @override
  void mount(Element? parent, Object? newSlot) {
    statefulWidget = widget.withState(widget.createState(this));
    super.mount(parent, newSlot);
  }

  @override
  void update(covariant StatefulFleetWidget newWidget) {
    super.update(newWidget);
    statefulWidget = newWidget.withState(statefulWidget!._state);
    // TODO: we should just call rebuild() here, but before we would need to
    // mark the widget as dirty, like StatelessElement does.
    // But _dirty is private.
    // Not sure what the downsides of calling markNeedsBuild() here are.
    markNeedsBuild();
  }

  @override
  Widget build() {
    return statefulWidget!.build(this);
  }
}

Object? _currentTransaction;

final _changeSets = <_ChangeSet>[];

var _isFirstChangeSet = true;

void _recordChange(_Change change) {
  _ChangeSet changeSet;
  if (_changeSets.isEmpty) {
    changeSet = _startTransaction();
    TransactionBinding.instance!
        .scheduleTransaction(changeSet.transaction, _runChangeSet);
  } else {
    changeSet = _changeSets.last;
    if (changeSet.transaction != _currentTransaction) {
      changeSet = _startTransaction();
    }
  }
  changeSet.changes.add(change);
}

_ChangeSet _startTransaction() {
  final changeSet = _ChangeSet(_currentTransaction);
  _changeSets.add(changeSet);
  return changeSet;
}

void _runChangeSet() {
  if (_isFirstChangeSet) {
    _isFirstChangeSet = false;
    _ChangeSet.reverseAll(_changeSets);
  }

  _changeSets.removeAt(0).apply();

  if (_changeSets.isNotEmpty) {
    TransactionBinding.instance!
        .scheduleTransaction(_changeSets.first.transaction, _runChangeSet);
  } else {
    _isFirstChangeSet = true;
  }
}

class _ChangeSet {
  _ChangeSet(this.transaction);

  static void reverseAll(List<_ChangeSet> changesSets) {
    for (final changeSet in changesSets.reversed) {
      changeSet.reverse();
    }
  }

  final Object? transaction;
  final List<_Change> changes = [];

  void apply() {
    for (final change in changes) {
      change.apply();
    }
  }

  void reverse() {
    for (final change in changes.reversed) {
      change.reverse();
    }
  }
}

abstract class _Change {
  void apply();
  void reverse();
}

class _StateChange extends _Change {
  _StateChange(this.element, this._apply, this._reverse);

  final StatefulFleetElement element;
  final VoidCallback _apply;
  final VoidCallback _reverse;

  @override
  void apply() {
    _apply();
    element.markNeedsBuild();
  }

  @override
  void reverse() {
    _reverse();
  }
}

// === Handwritten =============================================================

@fleetWidget
mixin _MyWidget on FleetWidgetBase {
  int get a;

  @state
  int get _b => 0;
  set _b(int value);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _b++;
      },
      child: Text('a: $a, _b: $_b'),
    );
  }
}

// === Generated ===============================================================

class MyWidget extends StatefulFleetWidget with _MyWidget {
  const MyWidget({
    super.key,
    required this.a,
  });

  @override
  _MyWidgetState get _state =>
      throw UnsupportedError('Widget instance is immutable.');

  @override
  final int a;

  @override
  int get _b => _state._b;

  @override
  set _b(int value) => _state._b = value;

  @override
  Object createState(StatefulFleetElement element) {
    return _MyWidgetState(
      element,
      super._b,
    );
  }

  @override
  StatefulFleetWidget withState(covariant _MyWidgetState state) {
    return _MyWidgetWithState(
      key: key,
      a: a,
      state: state,
    );
  }
}

class _MyWidgetWithState extends MyWidget {
  const _MyWidgetWithState({
    super.key,
    required super.a,
    required _MyWidgetState state,
  }) : _state = state;

  @override
  final _MyWidgetState _state;
}

class _MyWidgetState {
  _MyWidgetState(this.element, this.__b);

  final StatefulFleetElement element;

  int __b;

  int get _b => __b;

  set _b(int newValue) {
    if (__b != newValue) {
      final oldValue = __b;
      __b = newValue;
      _recordChange(
        _StateChange(element, () => __b = newValue, () => __b = oldValue),
      );
    }
  }
}
