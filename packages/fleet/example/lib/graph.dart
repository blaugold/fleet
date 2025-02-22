import 'package:fleet/fleet.dart';
import 'package:flutter/material.dart' hide Action;

import 'app.dart';

final _scale = TweenValue.double$(value: 1, name: 'scale');
final _rotation = TweenValue.double$(name: 'rotation');
final _opacity = TweenValue.double$(value: 1, name: 'opacity');
final _color = TweenValue.color(value: Colors.pink, name: 'color');
final _offset = TweenValue.offset(name: 'offset');

AnimationNode _buildAnimation() {
  // An animation graph is an immutable data structure that represents an
  // animation. It is built by composing animation nodes. Group runs its
  // children in parallel, Sequence runs its children in sequence.
  return ValueAnimationDefaults(
    curve: Curves.ease,
    Sequence([
      // Here we reset all animated values to their default value.
      // This is necessary, in case the animation has already been run, because
      // the animated values are not reset automatically.
      // Unless `AnimatedValue.to(from: ...)` is specified, the animation of
      // that value starts from the value that was last set, either by an
      // animation or directly.
      Group([
        _scale.jump(1),
        _rotation.jump(0),
        _opacity.jump(1),
        _color.jump(Colors.pink),
        _offset.jump(Offset.zero),
      ]),
      Group([
        _scale.to(2, over: 300.ms),
        _rotation.to(.25, over: 300.ms),
        _opacity.to(1, from: 0, over: 200.ms, curve: Curves.linear),
      ]),
      Pause(500.ms),
      Group([
        _color.to(Colors.teal, over: 500.ms, curve: Curves.linear),
        _scale.to(1, over: 500.ms),
        _offset.to(const Offset(300, 0), over: 500.ms).delay(200.ms),
        _opacity.to(0, over: 1.s, curve: Curves.linear).delay(300.ms),
      ]),
      // ignore: avoid_print
      Action(() => print('Animation completed')),
    ]),
  )
      // The speed of all nodes in the animation graph can be adjusted by
      // this single call. This is useful for debugging purposes.
      .speed(1);
}

void main() {
  runApp(const ExampleApp(page: Page()));
}

class Page extends StatefulWidget {
  const Page({super.key});

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page>
    with TickerProviderStateMixin, AnimationGraphMixin {
  void _animate() {
    // Cancel all running animations before starting a new one, in case the
    // previous animation has not completed. If two animations are run in
    // parallel that affect the same value, the result can be unpredictable.
    cancelAllAnimations();
    animate(_buildAnimation());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
          alignment: Alignment.center,
          children: [
            TranslateTransition(
              offset: _offset,
              child: RotationTransition(
                turns: _rotation,
                child: ScaleTransition(
                  scale: _scale,
                  child: FadeTransition(
                    opacity: _opacity,
                    child: _ColoredSquare(color: _color),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _animate,
              child: const Text('Animate'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ColoredSquare extends StatelessWidget {
  const _ColoredSquare({required this.color});

  final Value<Color> color;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 200,
      child: ValueListenableBuilder(
        valueListenable: color,
        builder: (context, color, _) {
          return ColoredBox(color: color);
        },
      ),
    );
  }
}

class TranslateTransition extends AnimatedWidget {
  const TranslateTransition({
    super.key,
    required Animation<Offset> offset,
    required this.child,
  }) : super(listenable: offset);

  Animation<Offset> get offset => listenable as Animation<Offset>;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: offset.value,
      child: child,
    );
  }
}
