import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/todo_model.dart';
import '../services/todo_service.dart';
import '../widgets/todo_list.dart';
import '../widgets/todo_form.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Todo> _todos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadTodos());
  }

  Future<void> _loadTodos() async {
    setState(() => _isLoading = true);
    try {
      final todoService = Provider.of<TodoService>(context, listen: false);
      final todos = await todoService.getTodos();
      setState(() {
        _todos = todos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load todos: $e')),
      );
    }
  }

  void _showAddTodoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Todo'),
        content: TodoForm(
          onSubmit: (title, description) async {
            final todoService = Provider.of<TodoService>(context, listen: false);
            await todoService.createTodo(title, description);
            Navigator.pop(context);
            _loadTodos();
          },
        ),
      ),
    );
  }

  void _showEditTodoDialog(Todo todo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Todo'),
        content: TodoForm(
          todo: todo,
          onSubmit: (title, description) async {
            final todoService = Provider.of<TodoService>(context, listen: false);
            await todoService.updateTodoDetails(todo, title, description);
            Navigator.pop(context);
            _loadTodos();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TodoList(
              todos: _todos,
              onToggle: (todo) async {
                final todoService = Provider.of<TodoService>(context, listen: false);
                await todoService.toggleTodoStatus(todo);
                _loadTodos();
              },
              onEdit: _showEditTodoDialog,
              onDelete: (id) async {
                final todoService = Provider.of<TodoService>(context, listen: false);
                await todoService.deleteTodo(id);
                _loadTodos();
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTodoDialog,
        tooltip: 'Add Todo',
        child: const Icon(Icons.add),
      ),
    );
  }
}