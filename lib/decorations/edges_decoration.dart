import 'package:flutter/material.dart';
import 'package:node_editor/constants.dart';
import 'package:node_editor/node_definition.dart';

@immutable
class EdgeDescription {
  final NodeData outputNode;
  final String outputName;
  final NodeData inputNode;
  final String inputName;
  final Type type;

  const EdgeDescription({
    required this.outputNode,
    required this.outputName,
    required this.inputNode,
    required this.inputName,
    required this.type,
  });
}

class DraggingEdge {
  final NodeData node;
  final String name;
  final bool output;
  final Type type;
  Offset position;

  DraggingEdge({
    required this.node,
    required this.name,
    required this.output,
    required this.type,
    required this.position,
  });
}

class EdgesBoxPainter extends BoxPainter {
  const EdgesBoxPainter(super.onChanged, this.edges, this.draggingEdges);

  final List<EdgeDescription> edges;
  final List<DraggingEdge> draggingEdges;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    for (final edge in edges) {
      final outputConnectorRenderBox = edge
          .outputNode.socketKeys[edge.outputName]?.currentContext
          ?.findRenderObject();
      final inputConnectorRenderBox = edge
          .inputNode.socketKeys[edge.inputName]?.currentContext
          ?.findRenderObject();

      if (inputConnectorRenderBox == null || outputConnectorRenderBox == null) {
        continue;
      }
      final output = (outputConnectorRenderBox as RenderBox)
          .localToGlobal(const Offset(connectorSize, connectorSize / 2));
      final input = (inputConnectorRenderBox as RenderBox)
          .localToGlobal(const Offset(connectorSize, connectorSize / 2));

      final path = Path();
      path.moveTo(output.dx, output.dy);
      path.cubicTo(output.dx + 100, output.dy, input.dx - 100, input.dy,
          input.dx, input.dy);

      final paint = Paint();
      paint.color = typeColorPalette[edge.type] ?? Colors.red;
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = edgeWidth;

      canvas.drawPath(path, paint);
    }
    for (final edge in draggingEdges) {
      final connectorRenderBox =
          edge.node.socketKeys[edge.name]?.currentContext?.findRenderObject();

      if (connectorRenderBox == null) {
        continue;
      }
      final start = (connectorRenderBox as RenderBox)
          .localToGlobal(const Offset(connectorSize, connectorSize / 2));

      final path = Path();

      if (edge.output) {
        path.moveTo(start.dx, start.dy);
        path.cubicTo(start.dx + 100, start.dy, edge.position.dx - 100,
            edge.position.dy, edge.position.dx, edge.position.dy);
      } else {
        path.moveTo(edge.position.dx, edge.position.dy);
        path.cubicTo(edge.position.dx + 100, edge.position.dy, start.dx - 100,
            start.dy, start.dx, start.dy);
      }

      final paint = Paint();
      paint.color = typeColorPalette[edge.type] ?? Colors.red;
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = edgeWidth;

      canvas.drawPath(path, paint);
    }
  }
}

class EdgesDecoration extends Decoration {
  const EdgesDecoration({required this.edges, required this.draggingEdges});

  final List<EdgeDescription> edges;
  final List<DraggingEdge> draggingEdges;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return EdgesBoxPainter(onChanged, edges, draggingEdges);
  }
}
