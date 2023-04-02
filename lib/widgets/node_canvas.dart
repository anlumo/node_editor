import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:node_editor/constants.dart';
import 'package:node_editor/cubit/node_cubit.dart';
import 'package:node_editor/node_definition.dart';
import 'package:node_editor/widgets/edge_widget.dart';
import 'package:node_editor/widgets/node_connector.dart';
import 'package:node_editor/widgets/node_widget.dart';
import 'package:uuid/uuid.dart';

class DraggingEdge {
  Offset destination;
  Offset source;
  Color color;
  bool output;

  DraggingEdge({
    required this.source,
    required this.destination,
    required this.color,
    required this.output,
  });
}

class NodeCanvas extends StatefulWidget {
  NodeCanvas(
      {Key? key,
      required this.nodeDefinitions,
      required this.nodes,
      required this.onInsertEdge})
      : super(key: key);

  final Map<String, NodeDefinition> nodeDefinitions;
  final Map<UuidValue, NodeData> nodes;
  final Function(UuidValue outputNode, String outputName, UuidValue inputNode,
      String inputName, Type type) onInsertEdge;

  final GlobalKey stackKey = GlobalKey();

  @override
  State<NodeCanvas> createState() => _NodeCanvasState();
}

class _NodeCanvasState extends State<NodeCanvas> {
  LinkedHashMap<EdgeKey, DraggingEdge> draggingEdges = LinkedHashMap();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      key: widget.stackKey,
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
        ...widget.nodes.entries.map((keyvalue) {
          final definition = widget.nodeDefinitions[keyvalue.value.name];

          return definition != null
              ? BlocProvider(
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
                    color: definition.color,
                    inputs: definition.inputs,
                    outputs: definition.outputs,
                    onEdgeDragStart: (key, type, position, output) {
                      final renderBox =
                          widget.stackKey.currentContext?.findRenderObject();

                      if (renderBox != null) {
                        final localPosition =
                            (renderBox as RenderBox).globalToLocal(position);
                        setState(() {
                          draggingEdges[key] = DraggingEdge(
                            source: localPosition,
                            destination: localPosition,
                            color: typeColorPalette[type] ?? Colors.red,
                            output: output,
                          );
                        });
                      }
                    },
                    onEdgeDragUpdate: (key, position) {
                      final renderBox =
                          widget.stackKey.currentContext?.findRenderObject();

                      if (renderBox != null) {
                        final localPosition =
                            (renderBox as RenderBox).globalToLocal(position);
                        setState(() {
                          final edge = draggingEdges[key];
                          edge?.destination = localPosition;
                        });
                      }
                    },
                    onEdgeDragCancel: (key) {
                      setState(() {
                        draggingEdges.remove(key);
                      });
                    },
                    onEdgeDragEnd: (key) {
                      setState(() {
                        draggingEdges.remove(key);
                      });
                    },
                    onInsertEdge: widget.onInsertEdge,
                  ),
                )
              : const SizedBox();
        }).toList(growable: false),
        ...draggingEdges.values.map((draggingEdge) {
          final offset = Offset(
            min(draggingEdge.source.dx, draggingEdge.destination.dx),
            min(draggingEdge.source.dy, draggingEdge.destination.dy),
          );
          final from = draggingEdge.source - offset;
          final to = draggingEdge.destination - offset;
          return Positioned(
            left: offset.dx,
            top: offset.dy,
            child: EdgeWidget(
              size: Size(
                  (draggingEdge.source.dx - draggingEdge.destination.dx).abs(),
                  (draggingEdge.source.dy - draggingEdge.destination.dy).abs()),
              from: draggingEdge.output ? from : to,
              to: draggingEdge.output ? to : from,
              color: draggingEdge.color,
            ),
          );
        }),
      ],
    );
  }
}
