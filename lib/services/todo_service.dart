import 'dart:convert';
import 'package:http/http.dart' as http;
import '/models/todo.dart';

class TodoService {
  final String baseUrl = 'https://jsonplaceholder.typicode.com/todos';

  Future<List<Todo>> fetchTodos() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((todo) => Todo.fromJson(todo)).toList();
    } else {
      throw Exception('Failed to load todos');
    }
  }

  Future<void> createTodo(Todo todo) async {
    await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(todo.toJson()),
    );
  }

  Future<void> updateTodo(Todo todo) async {
    await http.put(
      Uri.parse('$baseUrl/${todo.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(todo.toJson()),
    );
  }

  Future<void> deleteTodo(int id) async {
    await http.delete(Uri.parse('$baseUrl/$id'));
  }
}
