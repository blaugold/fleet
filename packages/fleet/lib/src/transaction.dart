import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import 'common.dart';

// === Intermediate building ===================================================

final _postBuildCallbacks = <VoidCallback>[];

/// Schedules a [callback] to be called after the current build phase.
///
/// This is different from [SchedulerBinding.addPostFrameCallback] in that the
/// callback is also called after intermediate builds
/// ([IntermediateBuildExtension]).
void schedulePostBuildCallback(VoidCallback callback) {
  assert(
    SchedulerBinding.instance.schedulerPhase != SchedulerPhase.idle ||
        _isBuildingIntermediately,
  );

  if (!_isBuildingIntermediately && _postBuildCallbacks.isEmpty) {
    WidgetsBinding.instance.addPostFrameCallback(_runPostBuildCallbacks);
  }

  _postBuildCallbacks.add(callback);
}

void _runPostBuildCallbacks([Object? _]) {
  for (final callback in _postBuildCallbacks) {
    try {
      callback();
    } catch (exception, stack) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: exception,
          stack: stack,
          library: 'fleet',
          context: ErrorDescription('while running post build callback'),
        ),
      );
    }
  }
  _postBuildCallbacks.clear();
}

var _isBuildingIntermediately = false;

/// Extension that allows performing intermediate builds.
extension IntermediateBuildExtension on WidgetsBinding {
  /// Runs an intermediate build.
  ///
  /// Intermediate builds are performed outside of the normal frame building
  /// process, for example as part of handling an input event.
  ///
  /// All elements that have been marked as dirty before the intermediate build
  /// is started will be rebuilt.
  ///
  /// # Layout
  ///
  /// As part of an intermediate build, layout also has to be performed, to
  /// build elements that are children of elements which build their children
  /// during layout, for example [LayoutBuilder].
  ///
  /// This does not necessarily mean that any real layout work is performed. If
  /// the intermediate build did not change layout parameters, elements that
  /// build their children during layout schedule a layout pass just to rebuild
  /// their children.
  ///
  /// If multiple intermediate builds that change layout parameters are
  /// performed before the next frame is built, some layout work may be
  /// performed multiple times. This means that intermediate builds should only
  /// be used if absolutely necessary.
  void buildIntermediately() {
    // ignore: invalid_use_of_protected_member
    assert(!debugBuildingDirtyElements);
    assert(() {
      // ignore: invalid_use_of_protected_member
      debugBuildingDirtyElements = true;
      return true;
    }());

    _isBuildingIntermediately = true;

    buildOwner!.buildScope(renderViewElement!);
    pipelineOwner.flushLayout();
    buildOwner!.finalizeTree();

    _isBuildingIntermediately = false;

    _runPostBuildCallbacks();

    assert(() {
      // ignore: invalid_use_of_protected_member
      debugBuildingDirtyElements = false;
      return true;
    }());
  }
}

// === Transaction =============================================================

var _isInTransaction = false;
Object? _transaction;

/// Applies a [transaction] to the state changes caused by calling [block].
///
/// Returns the value returned by [block].
T withTransaction<T>(Object? transaction, Block<T> block) {
  final previousTransaction = _transaction;
  final isSameAsPreviousTransaction = previousTransaction == _transaction;
  final isRootTransaction = !_isInTransaction;

  if (isRootTransaction) {
    _isInTransaction = true;
  }

  if (isRootTransaction || !isSameAsPreviousTransaction) {
    // Ensure that all elements are in a clean state before running the block,
    // to isolate transactional changes from other changes.
    // TODO: If we could know that all elements are in a clean state, we could
    // skip this step.
    WidgetsBinding.instance.buildIntermediately();
  } else if (isSameAsPreviousTransaction) {
    return block();
  }

  _transaction = transaction;

  try {
    return block();
  } finally {
    // Build elements that became dirty while running the block.
    // This allows those elements to see the current transaction.
    WidgetsBinding.instance.buildIntermediately();

    _transaction = previousTransaction;
    if (isRootTransaction) {
      _isInTransaction = false;
    }
  }
}

/// A transaction allows you to associate an arbitrary value with a single build
/// of a group of widgets.
///
/// This is useful, for example, to handle the changes in state from one build
/// to the next as one unit.
///
/// [Transaction.of] returns the current transaction value at the provided
/// [BuildContext].
///
/// # Local transactions
///
/// Descendants of [Transaction] see the provided [transaction] value if they
/// are building because the ancestor [Transaction] was rebuilt.
///
/// Descendants see the [transaction] value of the closest ancestor
/// [Transaction]. A [Transaction] with [transaction] value `null` can be used
/// to hide the [transaction] value of the closest ancestor [Transaction].
///
/// # Global transactions
///
/// [withTransaction] allows you to apply a transaction to the state changes
/// caused by calling a callback.
class Transaction extends StatefulWidget {
  /// Creates a local transaction whose [transaction] value is only visible to
  /// descendants that are building at the same time as this widget.
  const Transaction({
    super.key,
    this.transaction,
    required this.child,
  });

  /// The transaction value that is visible to descendants of this widget.
  final Object? transaction;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget child;

  /// Returns the current transaction value that is visible at the location of
  /// the provided [context].
  static Object? of(BuildContext context) {
    final inheritedTransaction =
        _InheritedTransactionState.of(context)?._transaction;
    return inheritedTransaction ?? _transaction;
  }

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  Object? _transaction;

  void _clear() {
    _transaction = null;
  }

  @override
  void initState() {
    super.initState();
    _transaction = widget.transaction;
  }

  @override
  void didUpdateWidget(covariant Transaction oldWidget) {
    super.didUpdateWidget(oldWidget);
    _transaction = widget.transaction;
  }

  @override
  Widget build(BuildContext context) {
    if (_transaction != null) {
      // Schedule this transaction to be cleared after the current build.
      // This is necessary so that subsequent builds of descendants of this
      // transaction don't see the transaction value in those builds.
      //
      // We only need to clear the transaction value if we have one.
      _scheduleClearingOfLocalTransaction(this);
    }

    return _InheritedTransactionState(
      state: this,
      child: widget.child,
    );
  }
}

/// An [InheritedWidget] that is used to ensure that looking up a
/// [_TransactionState] is quick.
class _InheritedTransactionState extends InheritedWidget {
  const _InheritedTransactionState({
    required super.child,
    required this.state,
  });

  final _TransactionState state;

  static _TransactionState? of(BuildContext context) {
    final inheritedTransactionState = context
        .getElementForInheritedWidgetOfExactType<_InheritedTransactionState>()
        ?.widget as _InheritedTransactionState?;
    return inheritedTransactionState?.state;
  }

  @override
  bool updateShouldNotify(_InheritedTransactionState oldWidget) {
    return state._transaction != oldWidget.state._transaction;
  }
}

final _localTransactionClearingQueue = <_TransactionState>[];

void _scheduleClearingOfLocalTransaction(_TransactionState transaction) {
  if (_localTransactionClearingQueue.isEmpty) {
    schedulePostBuildCallback(_clearLocalTransactions);
  }

  _localTransactionClearingQueue.add(transaction);
}

void _clearLocalTransactions() {
  for (final transaction in _localTransactionClearingQueue) {
    transaction._clear();
  }
  _localTransactionClearingQueue.clear();
}
