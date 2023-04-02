import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:node_editor/constants.dart';
import 'package:node_editor/cubit/node_cubit.dart';
import 'package:node_editor/edge.dart';
import 'package:node_editor/widgets/node.dart';
import 'package:uuid/uuid.dart';

class NodeCanvas extends StatelessWidget {
  const NodeCanvas({Key? key, required this.backgroundColor}) : super(key: key);

  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: backgroundColor,
      child: Stack(
        children: [
          const Positioned(
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
          BlocProvider(
            create: (context) {
              final cubit =
                  NodeCubit(UuidValue("791b9c06-492f-455d-aba3-1118223e62b9"));
              cubit.loaded(
                x: 400,
                y: 300,
                name: 'Testing',
              );
              return cubit;
            },
            child: const Node(
              color: Color.fromARGB(255, 182, 0, 18),
              inputs: [
                InputSocket(name: 'int', type: int),
                InputSocket(name: 'double', type: double),
                InputSocket(name: 'string', type: String),
              ],
              outputs: [
                OutputSocket(name: 'int', type: int),
                OutputSocket(name: 'double', type: double),
                OutputSocket(name: 'string', type: String),
                OutputSocket(name: 'bool', type: bool),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
