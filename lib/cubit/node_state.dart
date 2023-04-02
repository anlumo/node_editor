part of 'node_cubit.dart';

@immutable
abstract class NodeState {}

class NodeInitial extends NodeState {}

class NodeData extends NodeState {
  NodeData({
    required this.x,
    required this.y,
    required this.name,
    required this.edges,
  });

  final double x;
  final double y;
  final String name;
  final List<Edge> edges;
}
