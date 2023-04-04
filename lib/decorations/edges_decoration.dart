import 'package:flutter/material.dart';
import 'package:node_editor/edge.dart';

class EdgesBoxPainter extends BoxPainter {
  const EdgesBoxPainter(super.onChanged, this.edges);

  final List<Edge> edges;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    for (final edge in edges) {
      // final path = Path();
      // path.moveTo(from.dx, from.dy);
      // path.cubicTo(from.dx + 100, from.dy, to.dx - 100, to.dy, to.dx, to.dy);

      // final paint = Paint();
      // paint.color = typeColorPalette[edge.type] ?? Colors.red;
      // paint.style = PaintingStyle.stroke;
      // paint.strokeWidth = edgeWidth;

      // canvas.drawPath(path, paint);
      print('draw $edge');
    }
  }
}

class EdgesDecoration extends Decoration {
  const EdgesDecoration(this.edges);

  final List<Edge> edges;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return EdgesBoxPainter(onChanged, edges);
  }
}
