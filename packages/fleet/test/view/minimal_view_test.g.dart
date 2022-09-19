// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'minimal_view_test.dart';

// **************************************************************************
// ViewGenerator
// **************************************************************************

abstract class _$MinimalView extends FleetView {}

class _MinimalViewImpl extends _MinimalView {
  _MinimalViewImpl(
    this._widget,
  );

  // ignore: unused_field
  MinimalView _widget;
}

class MinimalView extends FleetViewWidget {
  const MinimalView({
    super.key,
  });

  @override
  FleetView createView(
    ViewElement element,
  ) {
    return _MinimalViewImpl(this);
  }

  @override
  void updateWidget(
    FleetView view,
    MinimalView newWidget,
  ) {
    (view as _MinimalViewImpl)._widget = newWidget;
  }
}
