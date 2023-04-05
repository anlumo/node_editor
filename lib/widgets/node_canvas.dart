import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:node_editor/constants.dart';
import 'package:node_editor/decorations/edges_decoration.dart';
import 'package:node_editor/node_definition.dart';
import 'package:node_editor/utils.dart';
import 'package:node_editor/widgets/node_connector.dart';
import 'package:node_editor/widgets/node_widget.dart';
import 'package:uuid/uuid.dart';

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
    final edges = widget.nodes.values.expand((node) => node.edges).toSet();

    return DecoratedBox(
      position: DecorationPosition.foreground,
      decoration: EdgesDecoration(
          edges: filterMap(edges, (edge) {
            final inputNode = widget.nodes[edge.inputNode];
            final outputNode = widget.nodes[edge.outputNode];

            if (inputNode == null || outputNode == null) {
              return null;
            }

            return EdgeDescription(
              outputNode: outputNode,
              outputName: edge.output.name,
              inputNode: inputNode,
              inputName: edge.input.name,
              type: edge.type,
            );
          }).toList(growable: false),
          draggingEdges: draggingEdges.values.toList(growable: false)),
      child: Stack(
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
                ? NodeWidget(
                    id: keyvalue.key,
                    color: definition.color,
                    data: keyvalue.value,
                    inputs: definition.inputs,
                    outputs: definition.outputs,
                    onEdgeDragStart: (key, type, position, output) {
                      final inputNode = widget.nodes[key.id];
                      if (inputNode != null) {
                        setState(() {
                          draggingEdges[key] = DraggingEdge(
                            name: key.name,
                            node: inputNode,
                            output: output,
                            type: type,
                            position: position,
                          );
                        });
                      }
                    },
                    onEdgeDragUpdate: (key, position) {
                      final renderBox =
                          widget.stackKey.currentContext?.findRenderObject();

                      if (renderBox != null) {
                        setState(() {
                          draggingEdges[key]?.position = position;
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
                    onNodeMoved: (newPosition) {
                      setState(() {
                        widget.nodes[keyvalue.key]?.position = newPosition;
                      });
                    },
                  )
                : const SizedBox();
          }).toList(growable: false),
        ],
      ),
    );
  }
}
