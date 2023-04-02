import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:node_editor/constants.dart';
import 'package:node_editor/edge.dart';
import 'package:node_editor/widgets/node_connector.dart';
import 'package:node_editor/widgets/node_header.dart';

class Node extends StatelessWidget {
  const Node({
    Key? key,
    required this.x,
    required this.y,
    required this.title,
    required this.color,
    this.inputs,
    this.outputs,
  }) : super(key: key);

  final double x;
  final double y;
  final String title;
  final Color color;
  final List<InputSocket>? inputs;
  final List<OutputSocket>? outputs;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: x,
      top: y,
      child: FractionalTranslation(
        translation: const Offset(-.5, -.5), // center alignment
        child: InkWell(
          mouseCursor: SystemMouseCursors.grab,
          child: DecoratedBox(
            decoration: nodeDecoration,
            child: ClipRRect(
              borderRadius: nodeRadius,
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
                        title: title,
                        color: color,
                      ),
                    ),
                    NamedAreaGridPlacement(
                      areaName: 'inputs',
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            NodeConnector(
                              name: 'Input Line 1',
                              output: false,
                            ),
                            NodeConnector(
                              name: 'Input Line 2',
                              output: false,
                              open: false,
                            ),
                            NodeConnector(
                              name: 'Input Line 2',
                              output: false,
                            ),
                          ]),
                    ),
                    NamedAreaGridPlacement(
                      areaName: 'outputs',
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: const [
                            NodeConnector(
                              name: 'Output Line 1',
                              output: true,
                            ),
                            NodeConnector(
                              name: 'Output Line 2',
                              output: true,
                            ),
                            NodeConnector(
                              name: 'Output Line 2',
                              output: true,
                              open: false,
                            ),
                            NodeConnector(
                              name: 'Output Line 3',
                              output: true,
                            ),
                            NodeConnector(
                              name: 'Output Line 4',
                              output: true,
                            ),
                          ]),
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
