import 'package:flutter/material.dart';
import 'package:node_editor/constants.dart';

class NodeConnector extends StatelessWidget {
  const NodeConnector(
      {Key? key,
      required this.type,
      required this.name,
      this.open = true,
      this.output = false})
      : super(key: key);

  final Type type;
  final bool output;
  final bool open;
  final String name;

  @override
  Widget build(BuildContext context) {
    final connectorColor = typeColorPalette[type] ?? Colors.red;
    return Row(
      textDirection: output ? TextDirection.rtl : TextDirection.ltr,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: nodePadding.right),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: open ? Colors.transparent : connectorColor,
              shape: BoxShape.circle,
              border: Border.all(
                  color: connectorColor, width: connectorBorderWidth),
            ),
            child: const SizedBox(
              width: 10,
              height: 10,
            ),
          ),
        ),
        Text(
          name,
          style: const TextStyle(color: connectorTextColor),
        )
      ],
    );
  }
}
