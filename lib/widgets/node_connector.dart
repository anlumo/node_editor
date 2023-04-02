import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:node_editor/constants.dart';
import 'package:node_editor/cubit/node_cubit.dart';
import 'package:node_editor/edge.dart';
import 'package:uuid/uuid.dart';

@immutable
class EdgeKey {
  final UuidValue id;
  final String name;

  const EdgeKey({required this.id, required this.name});

  @override
  bool operator ==(Object other) {
    if (other is EdgeKey) {
      return other.id == id && other.name == name;
    }
    return false;
  }

  @override
  int get hashCode => (id.hashCode ^ name.hashCode);
}

class NodeConnector extends StatelessWidget {
  NodeConnector({
    Key? key,
    required this.type,
    required this.name,
    this.output = false,
    this.onEdgeDragStart,
    this.onEdgeDragUpdate,
    this.onEdgeDragCancel,
    this.onEdgeDragEnd,
  }) : super(key: key);

  final Type type;
  final bool output;
  final String name;

  final Function(EdgeKey key, Type type, Offset position, bool output)?
      onEdgeDragStart;
  final Function(EdgeKey key, Offset position)? onEdgeDragUpdate;
  final Function(EdgeKey key)? onEdgeDragCancel;
  final Function(EdgeKey key)? onEdgeDragEnd;

  final connectorKey = GlobalKey();

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
                feedback: const SizedBox(
                  width: connectorSize,
                  height: connectorSize,
                ),
                onDragStarted: () {
                  if (onEdgeDragStart != null) {
                    final renderBox =
                        connectorKey.currentContext?.findRenderObject();
                    if (renderBox != null) {
                      final size = (renderBox as RenderBox).size;
                      final position = renderBox.localToGlobal(
                          Offset(size.width / 2, size.height / 2));

                      final node = BlocProvider.of<NodeCubit>(context);
                      onEdgeDragStart!(EdgeKey(id: node.id, name: name), type,
                          position, output);
                    }
                  }
                },
                onDragUpdate: (details) {
                  if (onEdgeDragUpdate != null) {
                    final node = BlocProvider.of<NodeCubit>(context);
                    onEdgeDragUpdate!(EdgeKey(id: node.id, name: name),
                        details.globalPosition);
                  }
                },
                onDraggableCanceled: (velocity, offset) {
                  if (onEdgeDragCancel != null) {
                    final node = BlocProvider.of<NodeCubit>(context);
                    onEdgeDragCancel!(EdgeKey(id: node.id, name: name));
                  }
                },
                onDragEnd: (details) {
                  if (onEdgeDragEnd != null) {
                    final node = BlocProvider.of<NodeCubit>(context);
                    onEdgeDragEnd!(EdgeKey(id: node.id, name: name));
                  }
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: nodePadding.right),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: open ? Colors.transparent : connectorColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: connectorColor, width: connectorBorderWidth),
                    ),
                    child: SizedBox(
                      key: connectorKey,
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
