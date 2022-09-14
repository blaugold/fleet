import 'package:flutter/widgets.dart';

import 'annotation.dart';

/// A Fleet view widget.
///
/// # Code generation
///
/// Views require code generation. To generate the code for a view, annotate the
/// view class with the [ViewGen] annotation.
///
/// The name of the view class must start with an underscore. A class will be
/// generated that has the same name as the view class without the leading
/// underscore. This class has to be used to instantiate the view.
///
/// A view class must be abstract and extend [ViewWidget]. It must not implement
/// any other types or use mixins. The class must have only the default
/// constructor with the signature `({super.key})`.
///
/// # Examples
///
/// ## Minimal view
///
/// <!--
/// ```dart multi_begin
/// // ignore_for_file: URI_HAS_NOT_BEEN_GENERATED,UNUSED_ELEMENT
/// ```
/// -->
///
/// ```dart
/// import 'package:flutter/widgets.dart';
///
/// part 'minimal_view.g.dart';
///
/// @viewGen
/// abstract class _MinimalView extends ViewWidget {
///   _MinimalView({super.key});
///
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
///
/// <!--
/// ```dart multi_end
/// // Just a mock to make the analyzer happy, since we don't generate the
/// // code for the view.
/// class MinimalView extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return Container();
///   }
/// }
/// ```
/// -->
abstract class ViewWidget extends Widget {
  /// Constructor for subclasses.
  // ignore: prefer_const_constructors_in_immutables
  ViewWidget({super.key});

  /// Builds the widget tree for this view.
  Widget build(BuildContext context);

  @override
  Element createElement() => ViewElement(this);

  /// Internal method to create the state for a instantiation of this view.
  ///
  /// This should return null if the view does not have any state.
  ///
  /// The returned object will be used as the state for this view. It will be
  /// notified when the view widget changes through [updateWidget].
  ViewWidget? createState(ViewElement element) => null;

  /// Internal method to update the view widget for a stateful view.
  ///
  /// Only objects returned by [createState] will have this method called.
  void updateWidget(covariant ViewWidget newWidget) {}
}

/// An [Element] that is configured by a [ViewWidget].
class ViewElement extends ComponentElement {
  /// Creates an element that is configured by the given widget.
  ViewElement(ViewWidget super.widget);

  @override
  ViewWidget get widget => super.widget as ViewWidget;

  ViewWidget? _state;

  @override
  void mount(Element? parent, Object? newSlot) {
    _state = widget.createState(this);
    super.mount(parent, newSlot);
  }

  @override
  void update(covariant ViewWidget newWidget) {
    _state?.updateWidget(newWidget);
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
  Widget build() => (_state ?? widget).build(this);
}
