`animated_value` is an animation framework that animates state changes instead
of individual values.

This framework has been heavily inspired by the animation framework of
[SwiftUI][swiftui animation framework]. If you are familiar with it, you will
find most concepts familiar.

To give you an idea of using this framework, I'm going to show you how to add a
simple animation to a widget. Below is the unanimated version of the widget:

```dart
import 'package:animated_value/animated_value.dart';
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
**state-based animation**. Any widget you want to animate through
`animated_value` needs to support state-based animation. These widgets don't
have any special parameters related to animation and can be just as well used
without animation.

`animated_value` provides drop-in replacements for a number of generally useful
Flutter framework widgets (all with the prefix `A`). Any widget can be made to
support state-based animation through components provided by `animated_value`
(see `AnimatableStateMixin`). Issues or PRs for adding support for more widgets
are welcome!

`setStateWithAnimation` is from an extension on `State`. All state changes
caused by executing the callback will be animated. Note that the callback is not
immediately executed like it is the case for `setState`. Instead, it is executed
as part of building the next frame. In practice this seldomly makes a
difference.

The `AnimationSpec` that we pass to `setStateWithAnimation` specifies how to
animate from the old to the new state. `const AnimationSpec()` is the default
animation spec that uses `Curves.linear` and animations for 200ms.

# Getting started

1. Add `animated_value` to your `pubspec.yaml`:

```shell
flutter pub add animated_value
```

2. Add `AnimatedValueBinding.ensureInitialized()` to your `main` function:

```dart
import 'package:animated_value/animated_value.dart';
import 'package:flutter/material.dart';

void main() {
  AnimatedValueBinding.ensureInitialized();
  runApp(MyApp());
}
```

You need to use this binding instead of `WidgetsFlutterBinding`.

This step is currently necessary because of functionality that `animated_value`
requires, but is not yet available in Flutter. This step will become unnecessary
once the required functionality is available in Flutter. Unfortunately, this
also means that until that point animations with `animated_value` will not work
in tests because the test bindings cannot be extended in the same way
`WidgetsFlutterBinding` can. You can still use the `animated_value` framework in
tests but animated values will just jump to their final value.

Now you're ready to use `animated_value` in your Flutter app.

[swiftui animation framework]:
  https://developer.apple.com/documentation/swiftui/animations
