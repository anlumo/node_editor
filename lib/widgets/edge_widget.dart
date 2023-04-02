import 'package:flutter/material.dart';
import 'package:node_editor/constants.dart';

class EdgePainter extends CustomPainter {
  final Offset from;
  final Offset to;
  final Color color;

  const EdgePainter(
      {required this.from, required this.to, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    path.moveTo(from.dx, from.dy);
    path.cubicTo(from.dx + 100, from.dy, to.dx - 100, to.dy, to.dx, to.dy);

    final paint = Paint();
    paint.color = color;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = edgeWidth;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class EdgeWidget extends StatelessWidget {
  const EdgeWidget(
      {Key? key,
      required this.size,
      required this.from,
      required this.to,
      required this.color})
      : super(key: key);

  final Size size;
  final Offset from;
  final Offset to;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: size,
      painter: EdgePainter(from: from, to: to, color: color),
    );
  }
}
