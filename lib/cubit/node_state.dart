part of 'node_cubit.dart';

@immutable
abstract class NodeState {}

class NodeInitial extends NodeState {}

class NodeLoaded extends NodeState {
  NodeLoaded({required this.x, required this.y, required this.name});

  final double x;
  final double y;
  final String name;
}
