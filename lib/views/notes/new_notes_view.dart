import 'package:flutter/material.dart';

class NewNotesView extends StatefulWidget {
  const NewNotesView({super.key});

  @override
  State<NewNotesView> createState() => _NewNotesViewState();
}

class _NewNotesViewState extends State<NewNotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Notes'),
        backgroundColor: const Color.fromARGB(255, 78, 136, 207),
      ),
      body: const Text('Write your new notes here...'),
    );
  }
}
