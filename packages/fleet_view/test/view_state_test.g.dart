// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'view_state_test.dart';

// **************************************************************************
// ViewGenerator
// **************************************************************************

abstract class _$ClickCounterView extends FleetView {}

class _ClickCounterViewImpl extends _ClickCounterView {
  _ClickCounterViewImpl(
    this._element,
    this._widget,
  ) {
    // ignore: unnecessary_statements
    _clicks;
  }

  final ViewElement _element;

  // ignore: unused_field
  ClickCounterView _widget;

  @override
  String? get prefix {
    return _widget.prefix;
  }

  @override
  set _clicks(int value) {
    updateState<int>(super._clicks, value, (value, reason) {
      super._clicks = value;
      if (reason == SetStateReason.rebuild) {
        _element.markNeedsBuild();
      }
    });
  }
}

class ClickCounterView extends FleetViewWidget {
  const ClickCounterView({
    super.key,
    this.prefix,
  });

  final String? prefix;

  @override
  FleetView createView(
    ViewElement element,
  ) {
    return _ClickCounterViewImpl(element, this);
  }

  @override
  void updateWidget(
    FleetView view,
    ClickCounterView newWidget,
  ) {
    (view as _ClickCounterViewImpl)._widget = newWidget;
  }
}
