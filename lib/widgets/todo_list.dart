// lib/widgets/todo_list.dart
import 'package:flutter/material.dart';
import '../models/todo_model.dart';

class TodoList extends StatelessWidget {
  final List<Todo> todos;
  final Function(Todo) onToggle;
  final Function(Todo) onEdit;
  final Function(String) onDelete;

  const TodoList({
    Key? key,
    required this.todos,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (todos.isEmpty) {
      return const Center(
        child: Text('No todos yet. Add your first one!'),
      );
    }

    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        
        return Dismissible(
          key: Key(todo.id),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: (_) => onDelete(todo.id),
          child: ListTile(
            title: Text(
              todo.title,
              style: TextStyle(
                decoration: todo.isCompleted 
                    ? TextDecoration.lineThrough 
                    : TextDecoration.none,
              ),
            ),
            subtitle: Text(todo.description),
            leading: Checkbox(
              value: todo.isCompleted,
              onChanged: (_) => onToggle(todo),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => onEdit(todo),
            ),
          ),
        );
      },
    );
  }
}
