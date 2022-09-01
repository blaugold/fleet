[![CI](https://github.com/blaugold/fleet/actions/workflows/CI.yaml/badge.svg)](https://github.com/blaugold/fleet/actions/workflows/CI.yaml)
[![pub.dev](https://img.shields.io/pub/v/fleet)](https://pub.dev/packages/fleet)

> ⚠️ This package is in an early state of development. If you find any bugs or
> have any suggestions, please open an [issue][issues].

`fleet` is an animation framework that animates state changes instead of
individual values.

This framework has been heavily inspired by the animation framework of
[SwiftUI][swiftui animation framework]. If you are familiar with it, you will
find most concepts familiar.

To give you an idea of using this framework I'm going to show how to add a
simple animation to a widget. Below is the unanimated version of the widget:

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

Now lets animate the state change:

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

All we did was replace `ColoredBox` with `AColoredBox` and use
`setStateWithAnimation` instead of `setState`.

The `AColoredBox` widget is a drop-in replacement for `ColoredBox` that supports
**state-based animation**. Any widget you want to animate through `fleet` needs
to support state-based animation. These widgets don't have any special
parameters related to animation and can be just as well used without animation.

`fleet` provides drop-in replacements for a number of generally useful Flutter
framework widgets (all with the prefix `A`). Any widget can be made to support
state-based animation through components provided by `fleet` (see
`AnimatableStateMixin`). Issues or PRs for adding support for more widgets are
welcome!

`setStateWithAnimation` is from an extension on `State`. All state changes
caused by executing the callback will be animated. Note that the callback is not
immediately executed like it is the case for `setState`. Instead, it is executed
as part of building the next frame. In practice this seldomly makes a
difference.

The `AnimationSpec` that we pass to `setStateWithAnimation` specifies how to
animate from the old to the new state. `const AnimationSpec()` is the default
animation spec, which uses `Curves.linear` and animates for 200ms.

# Getting started

1. Add `fleet` to your `pubspec.yaml`:

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

This step is currently necessary because of functionality that `fleet` requires,
but is not yet available in Flutter. This step will become unnecessary once the
required functionality is available in Flutter. Unfortunately, this also means
that until that point animations with `fleet` will not work in tests because the
test bindings cannot be extended in the same way `WidgetsFlutterBinding` can.
You can still use the `fleet` framework in tests but animated values will just
jump to their final value.

Now you're ready to use `fleet` in your Flutter app.

---

**Gabriel Terwesten** &bullet; **GitHub**
**[@blaugold](https://github.com/blaugold)** &bullet; **Twitter**
**[@GTerwesten](https://twitter.com/GTerwesten)** &bullet; **Medium**
**[@gabriel.terwesten](https://medium.com/@gabriel.terwesten)**

[issues]: https://github.com/blaugold/fleet/issues
[swiftui animation framework]:
  https://developer.apple.com/documentation/swiftui/animations
