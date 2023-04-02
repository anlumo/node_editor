import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

part 'node_state.dart';

class NodeCubit extends Cubit<NodeState> {
  NodeCubit(this.id) : super(NodeInitial());

  final UuidValue id;

  void loaded({required double x, required double y, required String name}) {
    emit(NodeLoaded(x: x, y: y, name: name));
  }
}
