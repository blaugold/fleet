import 'package:flutter/widgets.dart';

import 'annotation.dart';

/// A Fleet view.
///
/// # Code generation
///
/// Views require code generation. To generate the code for a view, annotate the
/// view class with the [view] annotation.
///
/// The name of the view class must start with an underscore. A class will be
/// generated that has the same name as the view class without the leading
/// underscore. This class has to be used to use the view as a [Widget].
///
/// A view class must be abstract and extend [FleetView]. It must not implement
/// any other types or use mixins. The class must not have any constructors.
///
/// # Examples
///
/// ## Minimal view
///
/// ```dart no_analyze
/// import 'package:flutter/widgets.dart';
///
/// part 'minimal_view.g.dart';
///
/// @view
/// abstract class _MinimalView extends _$MinimalView {
///   @override
///   Widget build(BuildContext context) {
///     return const SizedBox();
///   }
/// }
///
/// void main() {
///   runApp(MinimalView());
/// }
/// ```
// ignore: one_member_abstracts
abstract class FleetView {
  /// Builds the content of this view.
  Widget build(BuildContext context);
}

/// A widget that hosts a [FleetView].
abstract class FleetViewWidget extends Widget {
  /// Constructor for subclasses.
  const FleetViewWidget({super.key});

  @override
  Element createElement() => ViewElement(this);

  /// Internal method which instantiates the view.
  FleetView createView(ViewElement element);

  /// Internal method to update the view when the widget changes.
  void updateWidget(FleetView view, covariant FleetViewWidget newWidget) {}
}

/// An [Element] that is configured by a [FleetViewWidget].
class ViewElement extends ComponentElement {
  /// Creates an element that is configured by the given widget.
  ViewElement(FleetViewWidget super.widget);

  @override
  FleetViewWidget get widget => super.widget as FleetViewWidget;

  late FleetView _view;

  @override
  void mount(Element? parent, Object? newSlot) {
    _view = widget.createView(this);
    super.mount(parent, newSlot);
  }

  @override
  void update(covariant FleetViewWidget newWidget) {
    widget.updateWidget(_view, newWidget);
    super.update(newWidget);
    // TODO: continue building directly
    // The Flutter framework currently does not allow us to mark this element as
    // dirt and rebuild it directly. We have to add it to the list of dirty
    // elements and let the BuildOwner rebuild it. This still happens in
    // the same frame, but is not how StatelessElement and StatefulElement work.
    // I suspect that using markNeedsBuild is not as performant as it could be.
    markNeedsBuild();
  }

  @override
  Widget build() => _view.build(this);
}
