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
const connectorBorderColor = Color.fromRGBO(200, 200, 200, 1);
const connectorInsideColor = Color.fromRGBO(100, 100, 100, 1);
const connectorTextColor = Color.fromRGBO(230, 230, 230, 1);
