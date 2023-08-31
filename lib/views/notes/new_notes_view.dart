import 'package:flutter/material.dart';
import 'package:mynotes/service/auth/auth_service.dart';
import 'package:mynotes/service/crud/note_service.dart';

class NewNotesView extends StatefulWidget {
  const NewNotesView({super.key});

  @override
  State<NewNotesView> createState() => _NewNotesViewState();
}

class _NewNotesViewState extends State<NewNotesView> {
  DatabaseNotes? _notes;
  late final NotesService _notesService;
  late final TextEditingController _textController;

  @override
  void initState() {
    _notesService = NotesService();
    _textController = TextEditingController();
    super.initState();
  }

  void _textControllerListener() async {
    final notes = _notes;
    if (notes == null) {
      return;
    }
    final text = _textController.text;
    await _notesService.updateNotes(
      notes: notes,
      text: text,
    );
  }

  void _setTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  Future<DatabaseNotes> createNewNotes() async {
    final existingNotes = _notes;
    if (existingNotes != null) {
      return existingNotes;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final email = currentUser.email!;
    final owner = await _notesService.getUser(email: email);
    return await _notesService.createNotes(owner: owner);
  }

  void _deleteNotesIfTextIsEmpty() {
    final note = _notes;
    if (_textController.text.isEmpty && note != null) {
      _notesService.deleteNote(id: note.id);
    }
  }

  void _saveNotesIfTextIsNotEmpty() async {
    final notes = _notes;
    final text = _textController.text;
    if (notes != null && text.isNotEmpty) {
      await _notesService.updateNotes(
        notes: notes,
        text: text,
      );
    }
  }

  @override
  void dispose() {
    _deleteNotesIfTextIsEmpty();
    _saveNotesIfTextIsNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Notes'),
        backgroundColor: const Color.fromARGB(255, 78, 136, 207),
      ),
      body: FutureBuilder(
          future: createNewNotes(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                _notes = snapshot.data as DatabaseNotes;
                _setTextControllerListener();
                return TextField(
                  controller: _textController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'Starting typing your notes here . . .',
                  ),
                );
              default:
                return const CircularProgressIndicator();
            }
          }),
    );
  }
}
