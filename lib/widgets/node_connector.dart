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
  final bool output;
  final Type type;

  const EdgeKey(
      {required this.id,
      required this.name,
      required this.output,
      required this.type});

  @override
  bool operator ==(Object other) {
    if (other is EdgeKey) {
      return other.id == id &&
          other.name == name &&
          other.output == output &&
          other.type == type;
    }
    return false;
  }

  @override
  int get hashCode =>
      (id.hashCode ^ name.hashCode ^ output.hashCode ^ type.hashCode);
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
    this.onInsertEdge,
  }) : super(key: key);

  final Type type;
  final bool output;
  final String name;

  final Function(EdgeKey key, Type type, Offset position, bool output)?
      onEdgeDragStart;
  final Function(EdgeKey key, Offset position)? onEdgeDragUpdate;
  final Function(EdgeKey key)? onEdgeDragCancel;
  final Function(EdgeKey key)? onEdgeDragEnd;
  final Function(UuidValue outputNode, String outputName, UuidValue inputNode,
      String inputName, Type type)? onInsertEdge;

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
        final node = BlocProvider.of<NodeCubit>(context);
        final key =
            EdgeKey(id: node.id, name: name, output: output, type: type);

        return Row(
          textDirection: output ? TextDirection.rtl : TextDirection.ltr,
          children: [
            MouseRegion(
              cursor: SystemMouseCursors.move,
              child: Draggable(
                data: key,
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

                      onEdgeDragStart!(key, type, position, output);
                    }
                  }
                },
                onDragUpdate: (details) {
                  if (onEdgeDragUpdate != null) {
                    onEdgeDragUpdate!(key, details.globalPosition);
                  }
                },
                onDraggableCanceled: (velocity, offset) {
                  if (onEdgeDragCancel != null) {
                    onEdgeDragCancel!(key);
                  }
                },
                onDragEnd: (details) {
                  if (onEdgeDragEnd != null) {
                    onEdgeDragEnd!(key);
                  }
                },
                child: DragTarget(
                    onWillAccept: (data) {
                      if (data is EdgeKey) {
                        return data.output != output && data.type == type;
                      }
                      return false;
                    },
                    onAccept: (data) {
                      if (onInsertEdge != null && data is EdgeKey) {
                        if (output) {
                          onInsertEdge!(
                              key.id, key.name, data.id, data.name, type);
                        } else {
                          onInsertEdge!(
                              data.id, data.name, key.id, key.name, type);
                        }
                      }
                    },
                    hitTestBehavior: HitTestBehavior.opaque,
                    builder: (context, accepted, rejected) {
                      final theme = Theme.of(context);
                      return Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: nodePadding.right),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: accepted.isEmpty
                                ? (open ? Colors.transparent : connectorColor)
                                : theme.colorScheme.secondary,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: accepted.isEmpty
                                    ? connectorColor
                                    : theme.colorScheme.secondary,
                                width: connectorBorderWidth),
                          ),
                          child: SizedBox(
                            key: connectorKey,
                            width: connectorSize,
                            height: connectorSize,
                          ),
                        ),
                      );
                    }),
              ),
            ),
            Text(name)
          ],
        );
      },
    );
  }
}
