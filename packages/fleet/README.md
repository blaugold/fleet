[![CI](https://github.com/blaugold/fleet/actions/workflows/CI.yaml/badge.svg)](https://github.com/blaugold/fleet/actions/workflows/CI.yaml)
[![pub.dev](https://img.shields.io/pub/v/fleet)](https://pub.dev/packages/fleet)

> ⚠️ This package is in an early state of development. If you find any bugs or
> have any suggestions, please open an [issue][issues].

**Fleet** is an animation framework for Flutter.

- [**State-based**][animated]: Animate transitions from one state to another.
- [**Declarative**][animationspec]: Describe an animation and apply it to a
  state change. No need to manage `AnimationController`s or `Tween`s.
- **Animatable widgets**: Comes out of the box with general purpose widgets that
  support animating with Fleet.
  - [**Extensible**][animatablestatemixin]: Any widget can be made to support
    animating with Fleet.
  - **Flexible**: Animatable widgets can be used with or without animations.
  - **Composable**: Widgets that build on animatable widgets are automatically
    animatable.
  - **Animate parameters individually**: Animate parameters of animatable widget
    individually, e.g. with different curves.
- **User-friendly**: Add and change animations with little refactoring.

# Getting started

1. Add Fleet to your `pubspec.yaml`:

```shell
flutter pub add fleet
```

2. Add `FleetBinding.ensureInitialized()` to your `main` function:

```dart
import 'package:fleet/fleet.dart';
import 'package:flutter/material.dart';

void main() {
  FleetBinding.ensureInitialized();
  runApp(MyApp());
}
```

You need to use this binding instead of `WidgetsFlutterBinding`.

This step is currently necessary because of functionality that Fleet requires,
but that is not available in Flutter. This step will become unnecessary if and
when the required functionality becomes available in Flutter. Unfortunately,
this also means that until that point, animations that use Fleet will not work
in tests. The reason is that the test bindings cannot be extended in the same
way that `WidgetsFlutterBinding` can be. You can still use Fleet in tests but
animated values will immediately jump to their final value.

Now you're ready to use Fleet in your Flutter app.

Take a look a the [examples][example_app] or continue to the introduction to
Fleet.

# Introduction

Fleet has been heavily inspired by the animation framework that comes with
[SwiftUI][swiftui animation framework]. If you are familiar with it, you will
find most concepts familiar.

I'm going to walk you through adding a simple animation to a widget. Below is
the unanimated version of the widget:

```dart
import 'package:fleet/fleet.dart';
import 'package:flutter/material.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  var _active = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _active = !_active;
        });
      },
      child: ColoredBox(
        color: _active ? Colors.blue : Colors.grey,
      ),
    );
  }
}
```

Now lets animate the state change of `_active`:

```diff
 class _MyWidgetState extends State<MyWidget> {
   var _active = false;

   @override
   Widget build(BuildContext context) {
     return GestureDetector(
       onTap: () {
-        setState(() {
+        setStateWithAnimation(Curves.ease.animation(250.ms), () {
           _active = !_active;
         });
       },
-      child: ColoredBox(
+      child: AColoredBox(
         color: _active ? Colors.blue : Colors.grey,
       ),
     );
   }
 }
```

All we did was replace `ColoredBox` with [`AColoredBox`][acoloredbox] and use
[`setStateWithAnimation`][setstatewithanimation] instead of `setState`.

The `AColoredBox` widget is a drop-in replacement for `ColoredBox` that supports
animating with Fleet. Widgets that support animating with Fleet don't have any
special parameters related to animation and can be used without animation, just
as well.

Fleet provides drop-in replacements for a number of generally useful Flutter
framework widgets (all with the prefix `A`). Any widget can be made to support
state-based animation through components provided by Fleet (see
[`AnimatableStateMixin`][animatablestatemixin]). Issues or PRs for adding
support for more widgets are welcome!

Note that we did not explicitly tell `setStateWithAnimation` what to animate.
This is because Fleet uses a **state-based** approach. All state changes caused
by executing the provided callback will be animated. Even the state changes
which are indirect, like the `color` parameter of `AColoredBox` going from
`Colors.grey` to `Colors.blue`. Fleet does this by tracking the state of
animatable parameters of animatable widgets from one build to the next.

`setStateWithAnimation` is a little bit special in that it does not immediately
execute the callback, like it is the case for `setState`. Instead,
`setStateWithAnimation` executes the callback as part of building the next
frame. In practice this seldomly makes a difference. `setStateWithAnimation` is
a method from an extension on `State`.

`Curves.ease.animation(250.ms)` creates an [`AnimationSpec`][animationspec] that
we pass to `setStateWithAnimation` to specify how to animate from the old to the
new state.

`.animate` is an extension method on `Curve` that creates an
[`AnimationSpec`][animationspec] form the curve. It optionally takes a
`Duration`. For a nicer syntax for specifying `Duration`s, Fleet provides
extensions on `int`, e.g `250.ms` is equivalent to
`Duration(milliseconds: 250)`.

# Animatable widgets

The following drop-in replacements for Flutter framework widgets are provided
for animating with Fleet:

- AAlign
- AColoredBox
- AContainer
- AOpacity
- APadding
- APositioned
- APositionedDirectional
- ASizedBox
- ASliverOpacity
- ASliverPadding
- ATransform

---

**Gabriel Terwesten** &bullet; **GitHub**
**[@blaugold](https://github.com/blaugold)** &bullet; **Twitter**
**[@GTerwesten](https://twitter.com/GTerwesten)** &bullet; **Medium**
**[@gabriel.terwesten](https://medium.com/@gabriel.terwesten)**

[issues]: https://github.com/blaugold/fleet/issues
[swiftui animation framework]:
  https://developer.apple.com/documentation/swiftui/animations
[example_app]:
  https://github.com/blaugold/fleet/tree/main/packages/fleet/example
[withanimation]:
  https://pub.dev/documentation/fleet/latest/fleet/withAnimation.html
[setstatewithanimation]:
  https://pub.dev/documentation/fleet/latest/fleet/SetStateWithAnimationExtension/setStateWithAnimation.html
[animatablestatemixin]:
  https://pub.dev/documentation/fleet/latest/fleet/AnimatableStateMixin-mixin.html
[animationspec]:
  https://pub.dev/documentation/fleet/latest/fleet/AnimationSpec-class.html
[acoloredbox]:
  https://pub.dev/documentation/fleet/latest/fleet/AColoredBox-class.html
[animated]: https://pub.dev/documentation/fleet/latest/fleet/Animated-class.html
