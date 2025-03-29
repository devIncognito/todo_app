// lib/repositories/todo_repository.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo_model.dart';

class TodoRepository {
  static const String _storageKey = 'todos';

  // Get all todos
  Future<List<Todo>> getTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final todosJson = prefs.getStringList(_storageKey) ?? [];
    
    return todosJson
        .map((todoJson) => Todo.fromJson(jsonDecode(todoJson)))
        .toList();
  }

  // Save a new todo
  Future<void> addTodo(Todo todo) async {
    final prefs = await SharedPreferences.getInstance();
    final todosJson = prefs.getStringList(_storageKey) ?? [];
    
    todosJson.add(jsonEncode(todo.toJson()));
    await prefs.setStringList(_storageKey, todosJson);
  }

  // Update an existing todo
  Future<void> updateTodo(Todo todo) async {
    final prefs = await SharedPreferences.getInstance();
    final todosJson = prefs.getStringList(_storageKey) ?? [];
    
    final List<String> updatedTodosJson = [];
    
    for (final todoJson in todosJson) {
      final Map<String, dynamic> decodedTodo = jsonDecode(todoJson);
      if (decodedTodo['id'] == todo.id) {
        updatedTodosJson.add(jsonEncode(todo.toJson()));
      } else {
        updatedTodosJson.add(todoJson);
      }
    }
    
    await prefs.setStringList(_storageKey, updatedTodosJson);
  }

  // Delete a todo
  Future<void> deleteTodo(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final todosJson = prefs.getStringList(_storageKey) ?? [];
    
    final List<String> updatedTodosJson = todosJson
        .where((todoJson) => jsonDecode(todoJson)['id'] != id)
        .toList();
    
    await prefs.setStringList(_storageKey, updatedTodosJson);
  }

  // Clear all todos
  Future<void> clearTodos() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}
