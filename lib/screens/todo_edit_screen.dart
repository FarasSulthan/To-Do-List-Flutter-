import 'package:flutter/material.dart';
import '/models/todo.dart';
import '/services/todo_service.dart';

class TodoEditScreen extends StatelessWidget {
  final Todo? todo;

  TodoEditScreen({this.todo});

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController(text: todo?.title ?? '');

    return Scaffold(
      appBar: AppBar(
        title: Text(todo == null ? 'Add Todo' : 'Edit Todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final newTodo = Todo(
                  id: todo?.id ?? 0, // Id 0 if adding a new Todo
                  title: titleController.text,
                  completed: false,
                );

                if (todo == null) {
                  // Create new todo
                  TodoService().createTodo(newTodo);
                  Navigator.pop(context, newTodo); // Kembalikan Todo yang baru ditambahkan
                } else {
                  // Update existing todo
                  TodoService().updateTodo(newTodo);
                  Navigator.pop(context); // Hanya kembali
                }
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
