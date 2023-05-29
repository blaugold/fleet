import 'package:flutter/widgets.dart';

/// A key for accessing and modifying associated values from the [BuildContext].
///
/// [EnvironmentKey]s are an alternative to using [InheritedWidget]s for passing
/// values down the widget tree.
///
/// An [EnvironmentKey] is less verbose to define than an [InheritedWidget]
/// since it inherits the [of] and [maybeOf] methods instead of having to define
/// the equivalent static accessors.
///
/// It further incorporates the concept of a [defaultValue] which is used when
/// no value is provided through the [BuildContext].
///
/// # Example
///
/// The following example shows how to define a [EnvironmentKey], as well as a
/// extension method that is typically provided to make it easier to use.
///
/// ```dart multi_begin
/// import 'package:flutter/widgets.dart';
///
/// final class _DefaultPaddingKey
///     extends EnvironmentKey<double, _DefaultPaddingKey> {
///   const _DefaultPaddingKey();
///
///   @override
///   double defaultValue(BuildContext context) => 8;
/// }
///
/// const defaultPadding = _DefaultPaddingKey();
///
/// extension WidgetModifiers on Widget {
///   @widgetFactory
///   Widget defaultPadding(double amount) =>
///       const _DefaultPaddingKey().update(value: amount, child: this);
/// }
/// ```
///
/// To access the value of an [EnvironmentKey] from the [BuildContext], use the
/// [of] method:
///
/// ```dart multi_end
/// Widget build(BuildContext context) {
///   return Padding(
///     padding: EdgeInsets.all(defaultPadding.of(context)),
///     child: Container(),
///   );
/// }
/// ```
abstract base class EnvironmentKey<T, K extends EnvironmentKey<T, K>> {
  /// Constructor for subclasses.
  const EnvironmentKey();

  /// Returns the default value for this key, when no value is provided through
  /// the [BuildContext].
  T defaultValue(BuildContext context);

  /// Returns the value of this key form the given [BuildContext] or the
  /// [defaultValue] if no value is provided.
  T of(BuildContext context) => maybeOf(context) ?? defaultValue(context);

  /// Returns the value of this key based on the given [BuildContext] or `null`
  /// if no value is provided.
  T? maybeOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<_EnvironmentValue<T, K>>()
      ?.value;
}

/// Methods on [EnvironmentKey] for modifying the value of the key.
extension EnvironmentValueModifiers<T, K extends EnvironmentKey<T, K>>
    on EnvironmentKey<T, K> {
  /// Returns a widget that provides the given [value] for this key to its
  /// descendants.
  @widgetFactory
  Widget update({required T value, required Widget child}) {
    return _EnvironmentValue<T, K>(
      value: value,
      child: child,
    );
  }

  /// Returns a widget that provides the result of [transform] applied to the
  /// value of this key to its descendants.
  @widgetFactory
  Widget transform({
    required T Function(T value) transform,
    required Widget child,
  }) {
    return _EnvironmentValueTransformer(
      environmentKey: this,
      transform: transform,
      child: child,
    );
  }
}

final class _EnvironmentValue<T, K extends EnvironmentKey<T, K>>
    extends InheritedWidget {
  const _EnvironmentValue({
    required this.value,
    required super.child,
  });

  final T value;

  @override
  bool updateShouldNotify(covariant _EnvironmentValue<T, K> oldWidget) =>
      value != oldWidget.value;
}

final class _EnvironmentValueTransformer<T, K extends EnvironmentKey<T, K>>
    extends StatelessWidget {
  const _EnvironmentValueTransformer({
    required this.environmentKey,
    required this.transform,
    required this.child,
  });

  final K environmentKey;
  final T Function(T value) transform;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return environmentKey.update(
      value: transform(environmentKey.of(context)),
      child: child,
    );
  }
}
