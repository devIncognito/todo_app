// lib/services/todo_service.dart
import 'package:uuid/uuid.dart';
import '../models/todo_model.dart';
import '../repositories/todo_repository.dart';

class TodoService {
  final TodoRepository _repository;
  
  TodoService(this._repository);
  
  // Get all todos
  Future<List<Todo>> getTodos() async {
    return await _repository.getTodos();
  }
  
  // Create a new todo
  Future<Todo> createTodo(String title, String description) async {
    final todo = Todo(
      id: const Uuid().v4(),
      title: title,
      description: description,
      createdAt: DateTime.now(),
    );
    
    await _repository.addTodo(todo);
    return todo;
  }
  
  // Toggle todo completion status
  Future<Todo> toggleTodoStatus(Todo todo) async {
    final isCompleted = !todo.isCompleted;
    
    final updatedTodo = todo.copyWith(
      isCompleted: isCompleted,
      completedAt: isCompleted ? DateTime.now() : null,
    );
    
    await _repository.updateTodo(updatedTodo);
    return updatedTodo;
  }
  
  // Update todo details
  Future<Todo> updateTodoDetails(
    Todo todo, 
    String title, 
    String description
  ) async {
    final updatedTodo = todo.copyWith(
      title: title,
      description: description,
    );
    
    await _repository.updateTodo(updatedTodo);
    return updatedTodo;
  }
  
  // Delete a todo
  Future<void> deleteTodo(String id) async {
    await _repository.deleteTodo(id);
  }
  
  // Get pending todos count
  Future<int> getPendingTodosCount() async {
    final todos = await _repository.getTodos();
    return todos.where((todo) => !todo.isCompleted).length;
  }
  
  // Get completed todos count
  Future<int> getCompletedTodosCount() async {
    final todos = await _repository.getTodos();
    return todos.where((todo) => todo.isCompleted).length;
  }
}
