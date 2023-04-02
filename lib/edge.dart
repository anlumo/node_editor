class InputSocket {
  InputSocket({required this.name});

  final String name;
}

class OutputSocket {
  const OutputSocket({required this.name});

  final String name;
}

class Edge {
  final InputSocket? input;
  final OutputSocket? output;

  Edge({this.input, this.output});
}
