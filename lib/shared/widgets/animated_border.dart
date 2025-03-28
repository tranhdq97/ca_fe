import 'package:flutter/material.dart';

class AnimatedBorder extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;

  const AnimatedBorder({
    Key? key,
    required this.animation,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [animation.value, animation.value + 0.2],
          colors: const [
            Colors.red, // Gradient color
            Colors.transparent, // Transparent color
          ],
        ).createShader(bounds);
      },
      blendMode: BlendMode.srcATop,
      child: child,
    );
  }
}
