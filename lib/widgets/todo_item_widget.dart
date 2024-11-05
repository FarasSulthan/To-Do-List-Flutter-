import 'package:flutter/material.dart';
import '/models/todo.dart';

class TodoItemWidget extends StatelessWidget {
  final Todo todo;

  TodoItemWidget({required this.todo});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(todo.title),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          // Handle delete
        },
      ),
    );
  }
}
