import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:node_editor/constants.dart';
import 'package:node_editor/cubit/node_cubit.dart';
import 'package:node_editor/node_definition.dart';
import 'package:node_editor/widgets/node_widget.dart';
import 'package:uuid/uuid.dart';

class NodeCanvas extends StatelessWidget {
  const NodeCanvas(
      {Key? key, required this.nodeDefinitions, required this.nodes})
      : super(key: key);

  final Map<String, NodeDefinition> nodeDefinitions;
  final Map<UuidValue, NodeData> nodes;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          bottom: 0,
          child: GridPaper(
            color: theme.primaryColorLight,
            interval: gridSize,
            divisions: 1,
            subdivisions: 2,
          ),
        ),
        ...nodes.entries.map((keyvalue) {
          final definition = nodeDefinitions[keyvalue.value.name];

          return BlocProvider(
            create: (context) {
              final node = keyvalue.value;
              final cubit = NodeCubit(keyvalue.key);
              cubit.loaded(
                x: node.x,
                y: node.y,
                name: node.name,
                edges: node.edges,
              );
              return cubit;
            },
            child: NodeWidget(
              color: const Color.fromARGB(255, 182, 0, 18),
              inputs: definition?.inputs ?? [],
              outputs: definition?.outputs ?? [],
            ),
          );
        }).toList(growable: false),
      ],
    );
  }
}
