import 'package:flutter/material.dart';

const nodeRadius = BorderRadius.all(Radius.circular(8));
const nodePadding = EdgeInsets.all(8.0);
const nodeBackgroundColor = Color.fromRGBO(30, 30, 30, 1);
const nodeDecoration = BoxDecoration(
  borderRadius: nodeRadius,
  color: nodeBackgroundColor,
  boxShadow: [
    BoxShadow(blurRadius: 8),
  ],
);
const double gridSize = 200;
const gridColor = Color.fromRGBO(200, 200, 200, 0.6);

const double connectorBorderWidth = 2;
const connectorTextColor = Color.fromRGBO(230, 230, 230, 1);

const typeColorPalette = {
  int: Color.fromRGBO(255, 91, 91, 1),
  double: Color.fromRGBO(103, 255, 255, 1),
  String: Color.fromRGBO(179, 162, 255, 1),
  bool: Color.fromRGBO(140, 255, 174, 1),
};
