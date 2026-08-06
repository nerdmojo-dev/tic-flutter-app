import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class AnimatedSideBorderContainer extends StatelessWidget {
  final bool expanded;
  final Widget child;

  const AnimatedSideBorderContainer({
    super.key,
    required this.expanded,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: SideBorderPainter(),
      child: child,
    );
  }
}


class SideBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2;

    const dash = 8.0;
    const gap = 4.0;

    // Top
    double x = 0;
    while (x < size.width) {
      canvas.drawLine(
        Offset(x, 0),
        Offset((x + dash).clamp(0, size.width), 0),
        paint,
      );
      x += dash + gap;
    }

    // Bottom
    x = 0;
    while (x < size.width) {
      canvas.drawLine(
        Offset(x, size.height),
        Offset((x + dash).clamp(0, size.width), size.height),
        paint,
      );
      x += dash + gap;
    }

    // Left
    double y = 0;
    while (y < size.height) {
      canvas.drawLine(
        Offset(0, y),
        Offset(0, (y + dash).clamp(0, size.height)),
        paint,
      );
      y += dash + gap;
    }

    // Right
    y = 0;
    while (y < size.height) {
      canvas.drawLine(
        Offset(size.width, y),
        Offset(size.width, (y + dash).clamp(0, size.height)),
        paint,
      );
      y += dash + gap;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}