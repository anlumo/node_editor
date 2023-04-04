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
    required this.onNodeMoved,
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

  final Function(Offset newPosition) onNodeMoved;

  @override
  State<NodeWidget> createState() => _NodeWidgetState();
}

class _NodeWidgetState extends State<NodeWidget> {
  Offset? draggingStartPosition;
  Offset? draggingInitialNodePosition;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.data.position.dx,
      top: widget.data.position.dy,
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
                draggingInitialNodePosition = widget.data.position;
              });
            },
            onPanUpdate: (event) {
              widget.onNodeMoved(draggingInitialNodePosition! +
                  event.localPosition -
                  draggingStartPosition!);
            },
            onPanCancel: () {
              widget.onNodeMoved(draggingInitialNodePosition!);
              setState(() {
                draggingStartPosition = null;
                draggingInitialNodePosition = null;
              });
            },
            onPanEnd: (event) {
              setState(() {
                draggingStartPosition = null;
                draggingInitialNodePosition = null;
              });
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
