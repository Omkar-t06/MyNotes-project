import 'package:flutter/material.dart';
import 'package:mynotes/service/auth/auth_service.dart';
import 'package:mynotes/service/cloud/cloud_todos.dart';
import 'package:mynotes/service/cloud/firebase_cloud_storage.dart';
import 'package:mynotes/utilities/generics/get_arguments.dart';

class CreateUpdateTodosView extends StatefulWidget {
  const CreateUpdateTodosView({super.key});

  @override
  State<CreateUpdateTodosView> createState() => _CreateUpdateTodosViewState();
}

class _CreateUpdateTodosViewState extends State<CreateUpdateTodosView> {
  CloudTodos? _todos;
  late final FirebaseCloudStorage _todosService;
  late final TextEditingController _textControllerOfTitle;
  late final TextEditingController _textControllerOfdescrpition;
  late final DateTime? _selectedDate;
  late final bool _isCompleted;

  @override
  void initState() {
    _todosService = FirebaseCloudStorage();
    _textControllerOfTitle = TextEditingController();
    _textControllerOfdescrpition = TextEditingController();
    super.initState();
  }

  void _textControllerListener() async {
    final todos = _todos;

    if (todos == null) {
      return;
    }
    final title = _textControllerOfTitle.text;
    final description = _textControllerOfdescrpition.text;
    final dueDate = _selectedDate;
    await _todosService.updateTodo(
        documentId: todos.documentId,
        title: title,
        isComplete: _isCompleted,
        description: description,
        dueDate: dueDate);
  }

  void _setTextControllerListener() {
    _textControllerOfTitle.removeListener(_textControllerListener);
    _textControllerOfTitle.addListener(_textControllerListener);
    _textControllerOfdescrpition.removeListener(_textControllerListener);
    _textControllerOfdescrpition.addListener(_textControllerListener);
  }

  Future<CloudTodos> createOrGetExistingTodos(BuildContext context) async {
    final widgetTodos = context.getArgument<CloudTodos>();

    if (widgetTodos != null) {
      _todos = widgetTodos;
      _textControllerOfTitle.text = widgetTodos.title;
      _textControllerOfdescrpition.text = widgetTodos.description!;
      _selectedDate = widgetTodos.dueDate!;
      _isCompleted = widgetTodos.isCompleted;
      return widgetTodos;
    }
    final existingTodos = _todos;
    if (existingTodos != null) {
      return existingTodos;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id;
    final newTodos = await _todosService.createNewTodo(ownerUserId: userId);
    _todos = newTodos;
    return newTodos;
  }

  void _deleteTodosIfTitleIsEmpty() {
    final todos = _todos;
    if (_textControllerOfTitle.text.isEmpty && todos != null) {
      _todosService.deleteTodo(documentId: todos.documentId);
    }
  }

  void _saveTodosIfTitleIsNotEmpty() async {
    final todo = _todos;
    final title = _textControllerOfTitle.text;
    final description = _textControllerOfdescrpition.text;
    final dueDate = _selectedDate;
    final bool isCompleted = _isCompleted;
    if (todo != null && title.isNotEmpty) {
      await _todosService.updateTodo(
          documentId: todo.documentId,
          title: title,
          isComplete: isCompleted,
          description: description,
          dueDate: dueDate);
    }
  }

  @override
  void dispose() {
    _deleteTodosIfTitleIsEmpty();
    _saveTodosIfTitleIsNotEmpty();
    _textControllerOfTitle.dispose();
    _textControllerOfdescrpition.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Tasks',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 78, 136, 207),
      ),
      body: FutureBuilder(
        future: createOrGetExistingTodos(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _setTextControllerListener();
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _textControllerOfTitle,
                    decoration: const InputDecoration(
                      hintText: 'Start typing your task here...',
                    ),
                  ),
                  TextField(
                    controller: _textControllerOfdescrpition,
                    decoration: const InputDecoration(
                      hintText: 'Start typing your task description here...',
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                  ),
                  const Text(
                    "Select Due Date for Task:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _selectedDate = showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      ) as DateTime?;
                    },
                    child: const Text("Select Date"),
                  ),
                  ListTile(
                    title: const Text('Is task completed?'),
                    trailing: Checkbox(
                      onChanged: (bool? value) {
                        setState(() {
                          _isCompleted = value!;
                        });
                      },
                      value: _isCompleted,
                    ),
                  ),
                ],
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
