import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const MyHomePage(title: 'ToDo List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController _nameTask;

  List<String> todos = [];

  @override
  void initState() {
    super.initState();
    _nameTask = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _nameTask.dispose();
    super.dispose();
  }

  void addTask(context) {
    if (_nameTask.text.isNotEmpty) {
      setState(() {
        todos.add(_nameTask.text);
      });
      _nameTask.clear();
    }
  }

  Future<dynamic> _showlDialog(context) {
    return showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Apagar tarefa!'),
            content: const Text('Tem certeza que deseja apagar a tarefa?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  'Sim',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(
                  'Cancelar',
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _nameTask.clear();
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _nameTask,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Ex: Fazer tarefas...',
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Expanded(
                child: ListView.separated(
                  itemBuilder: (BuildContext context, int task) {
                    return ListTile(
                      title: Text(todos[task]),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete_forever_rounded,
                          color: Colors.red,
                        ),
                        onPressed: () async {
                          final delete = await _showlDialog(context);

                          if (delete) {
                            setState(() {
                              todos.removeAt(task);
                            });
                          }
                        },
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => const Divider(),
                  itemCount: todos.length,
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _nameTask.text.isEmpty ? null : addTask(context);
            FocusScope.of(context).unfocus();
          },
          tooltip: 'New task',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
