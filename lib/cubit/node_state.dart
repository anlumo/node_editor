part of 'node_cubit.dart';

@immutable
abstract class NodeState {}

class NodeInitial extends NodeState {}

class NodeLoaded extends NodeState {
  NodeLoaded({required this.data});

  final NodeData data;
}
