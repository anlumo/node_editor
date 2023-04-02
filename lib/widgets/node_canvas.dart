import 'package:flutter/material.dart';
import 'package:node_editor/constants.dart';
import 'package:node_editor/widgets/node.dart';

class NodeCanvas extends StatelessWidget {
  const NodeCanvas({Key? key, required this.backgroundColor}) : super(key: key);

  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: backgroundColor,
      child: Stack(
        children: const [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: GridPaper(
              color: gridColor,
              interval: gridSize,
              divisions: 1,
              subdivisions: 2,
            ),
          ),
          Node(
            x: 400,
            y: 300,
            title: 'Testing',
            color: Color.fromARGB(255, 182, 0, 18),
          ),
        ],
      ),
    );
  }
}
