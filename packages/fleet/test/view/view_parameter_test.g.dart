// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'view_parameter_test.dart';

// **************************************************************************
// ViewGenerator
// **************************************************************************

abstract class _$TextParameterView extends FleetView {}

class _TextParameterViewImpl extends _TextParameterView {
  _TextParameterViewImpl(
    this._widget,
  );

  // ignore: unused_field
  TextParameterView _widget;

  @override
  String get text {
    return _widget.text;
  }
}

class TextParameterView extends FleetViewWidget {
  const TextParameterView({
    super.key,
    required this.text,
  });

  final String text;

  @override
  FleetView createView(
    ViewElement element,
  ) {
    return _TextParameterViewImpl(this);
  }

  @override
  void updateWidget(
    FleetView view,
    TextParameterView newWidget,
  ) {
    (view as _TextParameterViewImpl)._widget = newWidget;
  }
}

abstract class _$OptionalParameterView extends FleetView {}

class _OptionalParameterViewImpl extends _OptionalParameterView {
  _OptionalParameterViewImpl(
    this._widget,
  );

  // ignore: unused_field
  OptionalParameterView _widget;

  @override
  String? get text {
    return _widget.text;
  }
}

class OptionalParameterView extends FleetViewWidget {
  const OptionalParameterView({
    super.key,
    this.text,
  });

  final String? text;

  @override
  FleetView createView(
    ViewElement element,
  ) {
    return _OptionalParameterViewImpl(this);
  }

  @override
  void updateWidget(
    FleetView view,
    OptionalParameterView newWidget,
  ) {
    (view as _OptionalParameterViewImpl)._widget = newWidget;
  }
}
