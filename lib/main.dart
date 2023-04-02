import 'package:flutter/material.dart';
import 'package:node_editor/cubit/node_cubit.dart';
import 'package:node_editor/node_definition.dart';
import 'package:node_editor/widgets/node_canvas.dart';
import 'package:uuid/uuid.dart';

const standardDefinitions = {
  'Add': NodeDefinition(
    name: 'Add',
    color: Color.fromARGB(255, 182, 0, 18),
    inputs: [
      InputSocket(name: 'a', type: double),
      InputSocket(name: 'b', type: double)
    ],
    outputs: [OutputSocket(name: 'out', type: double)],
  ),
  'Tick': NodeDefinition(
    name: 'Tick',
    color: Color.fromARGB(255, 0, 124, 182),
    inputs: [],
    outputs: [OutputSocket(name: 'out', type: double)],
  ),
  'Print': NodeDefinition(
    name: 'Print',
    color: Color.fromARGB(255, 235, 192, 0),
    inputs: [InputSocket(name: 'in', type: String)],
    outputs: [],
  ),
  'ToString': NodeDefinition(
    name: 'ToString',
    color: Color.fromARGB(255, 235, 153, 0),
    inputs: [InputSocket(name: 'in', type: double)],
    outputs: [OutputSocket(name: 'out', type: String)],
  ),
};

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Node Editor',
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
      home: const NodeEditor(),
    );
  }
}

const uuid = Uuid();

class NodeEditor extends StatefulWidget {
  const NodeEditor({super.key});

  @override
  State<NodeEditor> createState() => _NodeEditorState();
}

class _NodeEditorState extends State<NodeEditor> {
  Map<UuidValue, NodeData> nodes = {};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text('Node Editor'),
      ),
      body: Material(
        child: Row(
          children: [
            Expanded(
              child: NodeCanvas(
                nodeDefinitions: standardDefinitions,
                nodes: nodes,
              ),
            ),
            Material(
              color: theme.drawerTheme.backgroundColor,
              elevation: 10,
              child: SizedBox(
                width: 100,
                child: Column(
                    children: standardDefinitions.values.map((def) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                      onPressed: () {
                        setState(() {
                          nodes[uuid.v4obj()] = NodeData(
                            x: 100,
                            y: 100,
                            name: def.name,
                            edges: const [],
                          );
                        });
                      },
                      child: Text(def.name),
                    ),
                  );
                }).toList(growable: false)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
