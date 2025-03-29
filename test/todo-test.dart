// test/todo_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:uuid/uuid.dart';
import '../lib/models/todo_model.dart';
import '../lib/repositories/todo_repository.dart';
import '../lib/services/todo_service.dart';

@GenerateMocks([TodoRepository])
import 'todo_service_test.mocks.dart';

void main() {
  late MockTodoRepository mockRepository;
  late TodoService todoService;
  
  setUp(() {
    mockRepository = MockTodoRepository();
    todoService = TodoService(mockRepository);
  });
  
  group('TodoService', () {
    
    test('createTodo should create a new todo with given title and description', () async {
      // Arrange
      when(mockRepository.addTodo(any)).thenAnswer((_) async {});
      
      // Act
      final todo = await todoService.createTodo('Test Todo', 'Test Description');
      
      // Assert
      expect(todo.title, equals('Test Todo'));
      expect(todo.description, equals('Test Description'));
      expect(todo.isCompleted, equals(false));
      expect(todo.completedAt, isNull);
      verify(mockRepository.addTodo(any)).called(1);
    });
    
    test('toggleTodoStatus should change todo completion status', () async {
      // Arrange
      final todo = Todo(
        id: const Uuid().v4(),
        title: 'Test Todo',
        createdAt: DateTime.now(),
        isCompleted: false,
      );
      
      when(mockRepository.updateTodo(any)).thenAnswer((_) async {});
      
      // Act
      final updatedTodo = await todoService.toggleTodoStatus(todo);
      
      // Assert
      expect(updatedTodo.isCompleted, equals(true));
      expect(updatedTodo.completedAt, isNotNull);
      verify(mockRepository.updateTodo(any)).called(1);
    });
    
    test('updateTodoDetails should update title and description', () async {
      // Arrange
      final todo = Todo(
        id: const Uuid().v4(),
        title: 'Original Title',
        description: 'Original Description',
        createdAt: DateTime.now(),
      );
      
      when(mockRepository.updateTodo(any)).thenAnswer((_) async {});
      
      // Act
      final updatedTodo = await todoService.updateTodoDetails(
        todo, 
        'Updated Title', 
        'Updated Description'
      );
      
      // Assert
      expect(updatedTodo.title, equals('Updated Title'));
      expect(updatedTodo.description, equals('Updated Description'));
      verify(mockRepository.updateTodo(any)).called(1);
    });
    
    test('deleteTodo should call repository.deleteTodo', () async {
      // Arrange
      final todoId = const Uuid().v4();
      when(mockRepository.deleteTodo(any)).thenAnswer((_) async {});
      
      // Act
      await todoService.deleteTodo(todoId);
      
      // Assert
      verify(mockRepository.deleteTodo(todoId)).called(1);
    });
    
    test('getPendingTodosCount should return correct count', () async {
      // Arrange
      final todos = [
        Todo(id: '1', title: 'Todo 1', createdAt: DateTime.now(), isCompleted: false),
        Todo(id: '2', title: 'Todo 2', createdAt: DateTime.now(), isCompleted: true),
        Todo(id: '3', title: 'Todo 3', createdAt: DateTime.now(), isCompleted: false),
      ];
      
      when(mockRepository.getTodos()).thenAnswer((_) async => todos);
      
      // Act
      final count = await todoService.getPendingTodosCount();
      
      // Assert
      expect(count, equals(2));
    });
  });
}
