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

class Edge {
  final InputSocket? input;
  final OutputSocket? output;

  Edge({this.input, this.output});
}
