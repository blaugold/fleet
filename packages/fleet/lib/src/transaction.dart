import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

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
/// # Scheduled transactions
///
/// [scheduleTransaction] allows you to scheduled transactions to be executed as
/// part of the next frame. Each scheduled transaction has a callback that is
/// executed when there are **no** dirty widgets. After the callback finishes,
/// widgets that are now dirty are rebuilt and see the transaction value that
/// was provided when the transaction was scheduled.
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

  /// Schedules a transaction to be executed as part of the next frame.
  ///
  /// If a transaction is currently executing when another transaction is
  /// scheduled, the currently executing transaction is paused and the newly
  /// scheduled transaction is executed immediately. Before entering the newly
  /// scheduled transaction, any dirty widgets are rebuilt in the currently
  /// executing transaction. After the newly scheduled transaction finishes, the
  /// currently executing transaction is resumed. Transaction can be nested in
  /// this way arbitrarily deep.
  ///
  /// See [Transaction] for more information about transactions.
  static void scheduleTransaction(
    Object transaction,
    VoidCallback callback,
  ) {
    TransactionBinding.instance?.scheduleTransaction(transaction, callback);
  }

  /// Returns the current transaction value that is visible at the location of
  /// the provided [context].
  static Object? of(BuildContext context) {
    var transaction = _InheritedTransactionState.of(context)?._transaction;
    return transaction ??= TransactionBinding.instance?.scheduledTransaction;
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
      TransactionBinding.instance?._scheduleClearingOfLocalTransaction(this);
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
    // Readers don't care about the ancestor Transaction changing. They only
    // care about what the transaction value is at the time of the read.
    return false;
  }
}

/// Bindings for building with [Transaction]s.
mixin TransactionBinding on BindingBase, RendererBinding {
  /// The [TransactionBinding] instance for the current binding.
  static TransactionBinding? get instance => _instance;
  static TransactionBinding? _instance;

  @override
  void initInstances() {
    _instance = this;
    super.initInstances();
  }

  /// See [WidgetsBinding.buildOwner].
  BuildOwner? get buildOwner;

  /// See [WidgetsBinding.renderViewElement].
  Element? get renderViewElement;

  /// See [WidgetsBinding.debugBuildingDirtyElements].
  bool get debugBuildingDirtyElements;
  set debugBuildingDirtyElements(bool value);

  @override
  void drawFrame() {
    if (renderViewElement != null) {
      // Complete building widgets outside of scheduled transactions.
      // We need to flush the layout because some widgets get built during
      // layout.
      pipelineOwner.flushLayout();
      _clearLocalTransactions();

      _dispatchScheduledTransactions();
    } else {
      assert(_scheduledTransactions.isEmpty);
    }

    super.drawFrame();
  }

  final List<_TransactionState> _localTransactionStates = <_TransactionState>[];

  void _scheduleClearingOfLocalTransaction(_TransactionState transactionState) {
    assert(!_localTransactionStates.contains(transactionState));
    _localTransactionStates.add(transactionState);
  }

  void _clearLocalTransactions() {
    for (final localTransaction in _localTransactionStates) {
      localTransaction._clear();
    }
    _localTransactionStates.clear();
  }

  /// The transaction value of the currently building scheduled transaction.
  Object? get scheduledTransaction => _scheduledTransaction;
  Object? _scheduledTransaction;

  final List<MapEntry<Object, VoidCallback>> _scheduledTransactions =
      <MapEntry<Object, VoidCallback>>[];

  final _currentlyExecutingTransactions = <Object?>[];

  /// Schedules a transaction to be executed as part of the next frame.
  ///
  /// See [Transaction] for more information about transactions.
  void scheduleTransaction(Object transaction, VoidCallback callback) {
    if (_currentlyExecutingTransactions.isNotEmpty) {
      _executeTransaction(transaction, callback);
    } else {
      _scheduledTransactions.add(MapEntry(transaction, callback));
      ensureVisualUpdate();
    }
  }

  void _dispatchScheduledTransactions() {
    if (_scheduledTransactions.isEmpty) {
      return;
    }

    Timeline.startSync('TRANSACTIONS');

    for (final entry in _scheduledTransactions) {
      final transaction = entry.key;
      final callback = entry.value;

      assert(debugBuildingDirtyElements);
      debugBuildingDirtyElements = false;
      _executeTransaction(transaction, callback);
      debugBuildingDirtyElements = true;
    }

    _scheduledTransactions.clear();

    Timeline.finishSync();
  }

  @pragma('vm:notify-debugger-on-exception')
  void _executeTransaction(Object transaction, VoidCallback callback) {
    if (_currentlyExecutingTransactions.isNotEmpty) {
      _flushTransaction();
    }

    _currentlyExecutingTransactions.add(transaction);
    try {
      callback();
    } catch (exception, stack) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: exception,
          stack: stack,
          library: 'fleet library',
          context: ErrorDescription('while executing transaction'),
          informationCollector: () => [
            DiagnosticsProperty<Object>(
              'The transaction value was',
              transaction,
              style: DiagnosticsTreeStyle.errorProperty,
            )
          ],
        ),
      );
    }
    _flushTransaction();
    _currentlyExecutingTransactions.removeLast();
  }

  void _flushTransaction() {
    _transactionScope(_currentlyExecutingTransactions.last!, () {
      buildOwner!.buildScope(renderViewElement!);
      pipelineOwner.flushLayout();
      _clearLocalTransactions();
    });
  }

  void _transactionScope(Object transaction, VoidCallback callback) {
    final previousTransaction = _scheduledTransaction;
    _scheduledTransaction = transaction;
    try {
      callback();
    } finally {
      _scheduledTransaction = previousTransaction;
    }
  }
}
