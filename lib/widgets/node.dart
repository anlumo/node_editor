import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:node_editor/constants.dart';
import 'package:node_editor/cubit/node_cubit.dart';
import 'package:node_editor/edge.dart';
import 'package:node_editor/widgets/node_connector.dart';
import 'package:node_editor/widgets/node_header.dart';

class Node extends StatefulWidget {
  const Node({
    Key? key,
    required this.color,
    this.inputs,
    this.outputs,
  }) : super(key: key);

  final Color color;
  final List<InputSocket>? inputs;
  final List<OutputSocket>? outputs;

  @override
  State<Node> createState() => _NodeState();
}

class _NodeState extends State<Node> {
  Offset? draggingStartPosition;
  Offset? draggingOffset;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NodeCubit, NodeState>(
      builder: (context, state) {
        if (state is NodeLoaded) {
          return Positioned(
            left: state.x + (draggingOffset?.dx ?? 0),
            top: state.y + (draggingOffset?.dy ?? 0),
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
                      draggingOffset =
                          event.localPosition - draggingStartPosition!;
                    });
                  },
                  onPanCancel: () {
                    setState(() {
                      draggingStartPosition = null;
                      draggingOffset = null;
                    });
                  },
                  onPanEnd: (event) {
                    BlocProvider.of<NodeCubit>(context).loaded(
                      x: state.x + (draggingOffset?.dx ?? 0),
                      y: state.y + (draggingOffset?.dy ?? 0),
                      name: state.name,
                    );
                    setState(() {
                      draggingStartPosition = null;
                      draggingOffset = null;
                    });
                  },
                  child: DecoratedBox(
                    decoration: nodeDecoration,
                    child: ClipRRect(
                      borderRadius: nodeRadius,
                      child: Padding(
                        padding:
                            EdgeInsets.fromLTRB(0, 0, 0, nodePadding.bottom),
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
                                title: state.name,
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
                                              type: input.type,
                                              name: input.name,
                                              output: false,
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
                                              type: output.type,
                                              name: output.name,
                                              output: true,
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
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
