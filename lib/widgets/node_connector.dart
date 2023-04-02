import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:node_editor/constants.dart';
import 'package:node_editor/cubit/node_cubit.dart';
import 'package:node_editor/edge.dart';

class NodeConnector extends StatelessWidget {
  const NodeConnector(
      {Key? key, required this.type, required this.name, this.output = false})
      : super(key: key);

  final Type type;
  final bool output;
  final String name;

  @override
  Widget build(BuildContext context) {
    final connectorColor = typeColorPalette[type] ?? Colors.red;
    return BlocBuilder<NodeCubit, NodeState>(
      builder: (context, state) {
        final open = (state is NodeData)
            ? !(output
                ? state.edges
                    .any((Edge element) => element.output?.name == name)
                : state.edges
                    .any((Edge element) => element.input?.name == name))
            : true;

        return Row(
          textDirection: output ? TextDirection.rtl : TextDirection.ltr,
          children: [
            MouseRegion(
              cursor: SystemMouseCursors.move,
              child: Draggable(
                hitTestBehavior: HitTestBehavior.opaque,
                feedback: DecoratedBox(
                  decoration: BoxDecoration(
                    color: connectorColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: connectorColor, width: connectorBorderWidth),
                  ),
                  child: const SizedBox(
                    width: connectorSize,
                    height: connectorSize,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: nodePadding.right),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: open ? Colors.transparent : connectorColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: connectorColor, width: connectorBorderWidth),
                    ),
                    child: const SizedBox(
                      width: connectorSize,
                      height: connectorSize,
                    ),
                  ),
                ),
              ),
            ),
            Text(name)
          ],
        );
      },
    );
  }
}
