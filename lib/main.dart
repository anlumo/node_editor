import 'package:flutter/material.dart';
import 'package:node_editor/cubit/node_cubit.dart';
import 'package:node_editor/node_definition.dart';
import 'package:node_editor/widgets/node_canvas.dart';
import 'package:uuid/uuid.dart';

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
                nodeDefinitions: const {
                  'Add': NodeDefinition(
                    name: 'Add',
                    inputs: [
                      InputSocket(name: 'a', type: double),
                      InputSocket(name: 'b', type: double)
                    ],
                    outputs: [OutputSocket(name: 'out', type: double)],
                  ),
                  'Tick': NodeDefinition(
                    name: 'Tick',
                    inputs: [],
                    outputs: [OutputSocket(name: 'out', type: double)],
                  ),
                },
                nodes: nodes,
              ),
            ),
            Material(
              color: theme.drawerTheme.backgroundColor,
              elevation: 10,
              child: SizedBox(
                width: 100,
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                      onPressed: () {
                        setState(() {
                          nodes[uuid.v4obj()] = NodeData(
                              x: 100, y: 100, name: 'Add', edges: const []);
                        });
                      },
                      child: const Text('Add'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                      onPressed: () {
                        setState(() {
                          nodes[uuid.v4obj()] = NodeData(
                              x: 100, y: 100, name: 'Tick', edges: const []);
                        });
                      },
                      child: const Text('Tick'),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
