import 'package:node_editor/node_definition.dart';
import 'package:uuid/uuid.dart';

class Edge {
  final InputSocket input;
  final UuidValue inputNode;
  final OutputSocket output;
  final UuidValue outputNode;

  Edge({
    required this.inputNode,
    required this.input,
    required this.outputNode,
    required this.output,
  });

  Type get type => input.type;
}
