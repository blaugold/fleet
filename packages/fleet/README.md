[![CI](https://github.com/blaugold/fleet/actions/workflows/CI.yaml/badge.svg)](https://github.com/blaugold/fleet/actions/workflows/CI.yaml)
[![pub.dev](https://img.shields.io/pub/v/fleet)](https://pub.dev/packages/fleet)

> ⚠️ This package is in an early state of development. If you find any bugs or
> have any suggestions, please open an [issue][issues].

**Fleet** is an animation framework that animates state changes instead of
individual values.

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
+        setStateWithAnimation(const AnimationSpec(), () {
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
**state-based animation**. Any widget you want to animate through Fleet needs to
support state-based animation. These widgets don't have any special parameters
related to animation and can be just as well used without animation.

Fleet provides drop-in replacements for a number of generally useful Flutter
framework widgets (all with the prefix `A`). Any widget can be made to support
state-based animation through components provided by Fleet (see
[`AnimatableStateMixin`][animatablestatemixin]). Issues or PRs for adding
support for more widgets are welcome!

`setStateWithAnimation` is from an extension on `State`. All state changes
caused by executing the callback will be animated. Note that the callback is not
immediately executed like it is the case for `setState`. Instead, it is executed
as part of building the next frame. In practice this seldomly makes a
difference.

The [`AnimationSpec`][animationspec] that we pass to `setStateWithAnimation`
specifies how to animate from the old to the new state. `const AnimationSpec()`
is the default animation spec, which uses `Curves.linear` and animates for
200ms.

# Animatable widgets

The following drop-in replacements for Flutter framework widgets are provided
for animating with Fleet:

- AAlign
- AColoredBox
- AContainer
- ASizedBox

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
[setstatewithanimation]:
  https://pub.dev/documentation/fleet/latest/fleet/SetStateWithAnimationExtension/setStateWithAnimation.html
[animatablestatemixin]:
  https://pub.dev/documentation/fleet/latest/fleet/AnimatableStateMixin-mixin.html
[animationspec]:
  https://pub.dev/documentation/fleet/latest/fleet/AnimationSpec-class.html
[acoloredbox]:
  https://pub.dev/documentation/fleet/latest/fleet/AColoredBox-class.html
