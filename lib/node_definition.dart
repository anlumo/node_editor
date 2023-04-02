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
  final List<InputSocket> inputs;
  final List<OutputSocket> outputs;

  const NodeDefinition(
      {required this.name, required this.inputs, required this.outputs});
}
