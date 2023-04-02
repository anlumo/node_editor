import 'dart:math';

import 'package:flutter/material.dart';
import 'package:node_editor/constants.dart';

Color getTextColorForBackground(Color backgroundColor) {
  if (ThemeData.estimateBrightnessForColor(backgroundColor) ==
      Brightness.dark) {
    return Colors.white;
  }

  return Colors.black;
}

class NodeHeader extends StatelessWidget {
  const NodeHeader({
    super.key,
    required this.title,
    required this.color,
  });

  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final textColor = getTextColorForBackground(color);
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: SweepGradient(
          center: Alignment.topRight,
          startAngle: 0,
          endAngle: pi,
          colors: [nodeBackgroundColor, color],
        ),
      ),
      child: Padding(
        padding: nodePadding,
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}
