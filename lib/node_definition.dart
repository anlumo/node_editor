import 'dart:ui';

import 'package:node_editor/edge.dart';

class InputSocket {
  const InputSocket({required this.name, required this.type});

  final String name;
  final Type type;
}

class OutputSocket {
  const OutputSocket({required this.name, required this.type});

  final String name;
  final Type type;
}

class NodeDefinition {
  final String name;
  final Color color;
  final List<InputSocket> inputs;
  final List<OutputSocket> outputs;

  const NodeDefinition(
      {required this.name,
      required this.color,
      required this.inputs,
      required this.outputs});
}

class NodeData {
  NodeData({
    required this.x,
    required this.y,
    required this.name,
    required this.edges,
  });

  double x;
  double y;
  String name;
  List<Edge> edges;
}
