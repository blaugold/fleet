// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter_app.dart';

// **************************************************************************
// ViewGenerator
// **************************************************************************

abstract class _$App extends FleetView {}

class _AppImpl extends _App {
  _AppImpl(
    this._widget,
  );

  // ignore: unused_field
  App _widget;
}

class App extends FleetViewWidget {
  const App({
    super.key,
  });

  @override
  FleetView createView(
    ViewElement element,
  ) {
    return _AppImpl(this);
  }

  @override
  void updateWidget(
    FleetView view,
    App newWidget,
  ) {
    (view as _AppImpl)._widget = newWidget;
  }
}

abstract class _$CounterView extends FleetView {}

class _CounterViewImpl extends _CounterView {
  _CounterViewImpl(
    this._element,
    this._widget,
  ) {
    // ignore: unnecessary_statements
    counter;
  }

  final ViewElement _element;

  // ignore: unused_field
  CounterView _widget;

  @override
  set counter(int value) {
    updateState<int>(super.counter, value, (value, reason) {
      super.counter = value;
      if (reason == SetStateReason.rebuild) {
        _element.markNeedsBuild();
      }
    });
  }
}

class CounterView extends FleetViewWidget {
  const CounterView({
    super.key,
  });

  @override
  FleetView createView(
    ViewElement element,
  ) {
    return _CounterViewImpl(element, this);
  }

  @override
  void updateWidget(
    FleetView view,
    CounterView newWidget,
  ) {
    (view as _CounterViewImpl)._widget = newWidget;
  }
}
