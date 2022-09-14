// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'view_state_test.dart';

// **************************************************************************
// ViewGenerator
// **************************************************************************

class ClickCounterView extends _ClickCounterView {
  ClickCounterView({
    super.key,
    this.prefix,
  });

  @override
  final String? prefix;

  @override
  _ClickCounterViewState createState(
    ViewElement element,
  ) {
    return _ClickCounterViewState(element, this);
  }
}

class _ClickCounterViewState extends _ClickCounterView {
  _ClickCounterViewState(
    this._element,
    this._widget,
  );

  final ViewElement _element;

  ClickCounterView _widget;

  @override
  void updateWidget(
    ClickCounterView newWidget,
  ) {
    _widget = newWidget;
  }

  @override
  String? get prefix {
    return _widget.prefix;
  }

  @override
  set _clicks(int value) {
    super._clicks = value;
    _element.markNeedsBuild();
  }
}
