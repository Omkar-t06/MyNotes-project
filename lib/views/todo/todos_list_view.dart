import 'package:flutter/material.dart';
import 'package:mynotes/service/cloud/cloud_todos.dart';
import 'package:mynotes/utilities/dialog/delete_dialog.dart';

typedef TodosCallback = void Function(CloudTodos todo);

class TodoListView extends StatelessWidget {
  final Iterable<CloudTodos> todos;
  final TodosCallback onDeleteTodo;
  final TodosCallback onTap;
  const TodoListView({
    super.key,
    required this.todos,
    required this.onDeleteTodo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos.elementAt(index);
        return ListTile(
          onTap: () {
            onTap(todo);
          },
          title: Text(
            todo.title,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            onPressed: () async {
              final shouldDelete = await showDeleteDialog(context);
              if (shouldDelete) {
                onDeleteTodo(todo);
              }
            },
            icon: const Icon(Icons.delete),
          ),
        );
      },
    );
  }
}
