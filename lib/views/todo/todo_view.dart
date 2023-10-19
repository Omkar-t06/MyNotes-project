// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/constant/routes.dart';
import 'package:mynotes/enums/menu_actions.dart';
import 'package:mynotes/service/auth/auth_service.dart';
import 'package:mynotes/service/auth/bloc/auth_bloc.dart';
import 'package:mynotes/service/auth/bloc/auth_event.dart';
import 'package:mynotes/service/cloud/cloud_todos.dart';
import 'package:mynotes/service/cloud/firebase_cloud_storage.dart';
import 'package:mynotes/utilities/dialog/logout_dialog.dart';
import 'package:mynotes/views/todo/todos_list_view.dart';

class TodoView extends StatefulWidget {
  const TodoView({super.key});

  @override
  State<TodoView> createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> {
  late final FirebaseCloudStorage _todoService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _todoService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Your Tasks",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 78, 136, 207),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogOut = await showLogOutDialog(context);
                  if (shouldLogOut) {
                    context.read<AuthBloc>().add(
                          const AuthEventLogOut(),
                        );
                  }
                  break;
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Log Out'),
                )
              ];
            },
            color: Colors.white,
          )
        ],
      ),
      body: StreamBuilder(
        stream: _todoService.allTodos(ownerUsedId: userId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allTodos = snapshot.data as Iterable<CloudTodos>;
                return TodoListView(
                  todos: allTodos,
                  onDeleteTodo: (todo) async {
                    await _todoService.deleteTodo(documentId: todo.documentId);
                  },
                  onTap: (todo) {
                    Navigator.of(context).pushNamed(
                      createOrUpdateTodosRoute,
                      arguments: todo,
                    );
                  },
                  onCheckTodo: (CloudTodos todo) {
                    _todoService.updateTodo(
                      documentId: todo.documentId,
                      title: todo.title,
                      isComplete: !todo.isCompleted,
                      description: todo.description,
                      dueDate: todo.dueDate,
                    );
                  },
                );
              } else {
                return const CircularProgressIndicator();
              }
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(createOrUpdateTodosRoute);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
