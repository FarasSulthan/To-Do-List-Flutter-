import 'package:flutter/material.dart';
import '/services/todo_service.dart';
import '/models/todo.dart';
import 'todo_edit_screen.dart';

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  late Future<List<Todo>> futureTodos;
  List<Todo> allTodos = [];
  List<Todo> filteredTodos = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    futureTodos = TodoService().fetchTodos().then((todos) {
      setState(() {
        allTodos = todos;
        filteredTodos = todos;
      });
      return todos;
    });
  }

  void filterTodos(String query) {
    setState(() {
      searchQuery = query;
      filteredTodos = allTodos
          .where((todo) => todo.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To Do List // Faras Sulthan Pratama (5220411318)'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(filterTodos),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Todo>>(
        future: futureTodos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          return ListView.separated(
            itemCount: filteredTodos.length,
            separatorBuilder: (context, index) => Divider(height: 1),
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 2,
                child: ListTile(
                  title: Text(
                    filteredTodos[index].title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      decoration: filteredTodos[index].completed
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  subtitle: Text(filteredTodos[index].completed ? 'Completed' : 'Pending'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        TodoService().deleteTodo(filteredTodos[index].id);
                        allTodos.remove(filteredTodos[index]);
                        filterTodos(searchQuery); // Update filtered todos
                      });
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TodoEditScreen(todo: filteredTodos[index]),
                      ),
                    ).then((_) {
                      setState(() {
                        futureTodos = TodoService().fetchTodos().then((todos) {
                          allTodos = todos;
                          filterTodos(searchQuery); // Update filtered todos
                          return todos;
                        });
                      });
                    });
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TodoEditScreen()),
          ).then((_) {
            setState(() {
              futureTodos = TodoService().fetchTodos().then((todos) {
                allTodos = todos;
                filterTodos(searchQuery); // Update filtered todos
                return todos;
              });
            });
          });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  final Function(String) onQueryChanged;

  CustomSearchDelegate(this.onQueryChanged);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          onQueryChanged(query);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(); // Not used in this example
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    onQueryChanged(query);
    return Container(); // Not used in this example
  }
}
