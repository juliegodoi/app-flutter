import 'package:flutter/material.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const TodoHomePage(),
    );
  }
}

// Modelo de Tarefa
class Task {
  String title;
  bool isCompleted;

  Task({required this.title, this.isCompleted = false});
}

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({super.key});

  @override
  State<TodoHomePage> createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  final List<Task> _tasks = [];
  final TextEditingController _controller = TextEditingController();

  // Mostrar alerta de sucesso
  void _showSuccessSnackBar(String message, IconData icon, Color color) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Adicionar tarefa
  void _addTask() {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _tasks.add(Task(title: _controller.text.trim()));
      _controller.clear();
    });
    Navigator.pop(context);
    _showSuccessSnackBar(
      'Tarefa criada com sucesso!',
      Icons.check_circle,
      Colors.green,
    );
  }

  // Editar tarefa
  void _editTask(int index, String newTitle) {
    if (newTitle.trim().isEmpty) return;

    setState(() {
      _tasks[index].title = newTitle.trim();
    });
    _showSuccessSnackBar(
      'Tarefa editada com sucesso!',
      Icons.edit,
      Colors.green,
    );
  }

  // Excluir tarefa
  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
    _showSuccessSnackBar('Tarefa excluída!', Icons.delete, Colors.green);
  }

  // Alternar conclusão
  void _toggleComplete(int index) {
    final wasCompleted = _tasks[index].isCompleted;
    setState(() {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
    });
    if (!wasCompleted) {
      _showSuccessSnackBar(
        'Tarefa concluída! 🎉',
        Icons.celebration,
        Colors.green,
      );
    } else {
      _showSuccessSnackBar('Tarefa reaberta', Icons.refresh, Colors.green);
    }
  }

  // Diálogo para adicionar tarefa
  void _showAddTaskDialog() {
    _controller.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nova Tarefa'),
        content: TextField(
          controller: _controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Digite a tarefa...',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (_) => _addTask(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(onPressed: _addTask, child: const Text('Adicionar')),
        ],
      ),
    );
  }

  // Diálogo para editar tarefa
  void _showEditTaskDialog(int index) {
    final editController = TextEditingController(text: _tasks[index].title);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Tarefa'),
        content: TextField(
          controller: editController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Digite a tarefa...',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) {
            _editTask(index, value);
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              _editTask(index, editController.text);
              Navigator.pop(context);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '📋 Minhas Tarefas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: _tasks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.task_alt,
                    size: 80,
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhuma tarefa ainda!',
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Toque no + para adicionar',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: IconButton(
                      icon: Icon(
                        task.isCompleted
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: task.isCompleted
                            ? Colors.green
                            : Theme.of(context).colorScheme.primary,
                        size: 28,
                      ),
                      onPressed: () => _toggleComplete(index),
                    ),
                    title: Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 16,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: task.isCompleted
                            ? Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.5)
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, size: 22),
                          onPressed: () => _showEditTaskDialog(index),
                          tooltip: 'Editar',
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                            size: 22,
                          ),
                          onPressed: () => _deleteTask(index),
                          tooltip: 'Excluir',
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddTaskDialog,
        icon: const Icon(Icons.add),
        label: const Text('Nova Tarefa'),
      ),
    );
  }
}
