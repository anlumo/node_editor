import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:node_editor/constants.dart';
import 'package:node_editor/node_definition.dart';
import 'package:node_editor/widgets/node_connector.dart';
import 'package:node_editor/widgets/node_header.dart';
import 'package:uuid/uuid.dart';

class NodeWidget extends StatefulWidget {
  const NodeWidget({
    Key? key,
    required this.id,
    required this.color,
    required this.data,
    this.inputs,
    this.outputs,
    this.onEdgeDragStart,
    this.onEdgeDragUpdate,
    this.onEdgeDragCancel,
    this.onEdgeDragEnd,
    this.onInsertEdge,
  }) : super(key: key);

  final UuidValue id;
  final Color color;
  final List<InputSocket>? inputs;
  final List<OutputSocket>? outputs;
  final NodeData data;

  final Function(EdgeKey key, Type type, Offset position, bool output)?
      onEdgeDragStart;
  final Function(EdgeKey key, Offset position)? onEdgeDragUpdate;
  final Function(EdgeKey key)? onEdgeDragCancel;
  final Function(EdgeKey key)? onEdgeDragEnd;
  final Function(UuidValue outputNode, String outputName, UuidValue inputNode,
      String inputName, Type type)? onInsertEdge;

  @override
  State<NodeWidget> createState() => _NodeWidgetState();
}

class _NodeWidgetState extends State<NodeWidget> {
  Offset? draggingStartPosition;
  Offset? draggingOffset;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.data.x + (draggingOffset?.dx ?? 0),
      top: widget.data.y + (draggingOffset?.dy ?? 0),
      child: FractionalTranslation(
        translation: const Offset(-.5, -.5), // center alignment
        child: MouseRegion(
          cursor: draggingStartPosition != null
              ? SystemMouseCursors.grabbing
              : SystemMouseCursors.grab,
          child: GestureDetector(
            onPanDown: (event) {
              setState(() {
                draggingStartPosition = event.localPosition;
                draggingOffset = Offset.zero;
              });
            },
            onPanUpdate: (event) {
              setState(() {
                draggingOffset = event.localPosition - draggingStartPosition!;
              });
            },
            onPanCancel: () {
              setState(() {
                draggingStartPosition = null;
                draggingOffset = null;
              });
            },
            onPanEnd: (event) {
              if (draggingOffset != null) {
                widget.data.x += draggingOffset!.dx;
                widget.data.y += draggingOffset!.dy;
                setState(() {
                  draggingStartPosition = null;
                  draggingOffset = null;
                });
              }
            },
            child: Card(
              key: ValueKey(widget.id),
              elevation: 10,
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, nodePadding.bottom),
                child: LayoutGrid(
                  areas: '''
                          header header
                          inputs outputs
                        ''',
                  columnSizes: const [auto, auto],
                  rowSizes: const [auto, auto],
                  rowGap: nodePadding.top,
                  columnGap: nodePadding.left * 4,
                  children: [
                    NamedAreaGridPlacement(
                      areaName: 'header',
                      child: NodeHeader(
                        title: widget.data.name,
                        color: widget.color,
                      ),
                    ),
                    NamedAreaGridPlacement(
                      areaName: 'inputs',
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: widget.inputs
                                  ?.map(
                                    (input) => NodeConnector(
                                      id: widget.id,
                                      type: input.type,
                                      name: input.name,
                                      data: widget.data,
                                      output: false,
                                      onEdgeDragStart: widget.onEdgeDragStart,
                                      onEdgeDragUpdate: widget.onEdgeDragUpdate,
                                      onEdgeDragCancel: widget.onEdgeDragCancel,
                                      onEdgeDragEnd: widget.onEdgeDragEnd,
                                      onInsertEdge: widget.onInsertEdge,
                                    ),
                                  )
                                  .toList(growable: false) ??
                              []),
                    ),
                    NamedAreaGridPlacement(
                      areaName: 'outputs',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: widget.outputs
                                ?.map((output) => NodeConnector(
                                      id: widget.id,
                                      type: output.type,
                                      name: output.name,
                                      data: widget.data,
                                      output: true,
                                      onEdgeDragStart: widget.onEdgeDragStart,
                                      onEdgeDragUpdate: widget.onEdgeDragUpdate,
                                      onEdgeDragCancel: widget.onEdgeDragCancel,
                                      onEdgeDragEnd: widget.onEdgeDragEnd,
                                      onInsertEdge: widget.onInsertEdge,
                                    ))
                                .toList(growable: false) ??
                            [],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
