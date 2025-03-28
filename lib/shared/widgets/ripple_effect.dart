import 'package:flutter/material.dart';

class RippleEffect extends StatefulWidget {
  final Widget child;
  final bool isAnimating;

  const RippleEffect({
    Key? key,
    required this.child,
    required this.isAnimating,
  }) : super(key: key);

  @override
  _RippleEffectState createState() => _RippleEffectState();
}

class _RippleEffectState extends State<RippleEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Duration of the ripple animation
    )..repeat(); // Repeat the animation continuously
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (widget.isAnimating)
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: RipplePainter(_controller.value),
                child: widget.child,
              );
            },
          ),
        widget.child, // The child widget (e.g., the order card)
      ],
    );
  }
}

class RipplePainter extends CustomPainter {
  final double progress;

  RipplePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFC89933)
          .withOpacity(1 - progress) // Fade out as it expands
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    // Calculate the growing border rectangle
    final rect = Rect.fromLTWH(
      size.width * 0.05 * progress, // Left grows inward
      size.height * 0.05 * progress, // Top grows inward
      size.width * (1 - 0.1 * progress), // Width shrinks
      size.height * (1 - 0.1 * progress), // Height shrinks
    );

    // Draw a rounded rectangle (matching the card's border radius)
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(12.0)), // Match card radius
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Always repaint for animation
  }
}
