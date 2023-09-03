import 'package:flutter/material.dart';
import 'package:mynotes/service/auth/auth_service.dart';
import 'package:mynotes/service/cloud/firebase_cloud_storage.dart';
import 'package:mynotes/utilities/dialog/cannot_share_empty_notes.dart';
import 'package:mynotes/utilities/generics/get_arguments.dart';
import 'package:mynotes/service/cloud/cloud_notes.dart';
import 'package:share_plus/share_plus.dart';

class CreateUpdateNotesView extends StatefulWidget {
  const CreateUpdateNotesView({super.key});

  @override
  State<CreateUpdateNotesView> createState() => _CreateUpdateNotesViewState();
}

class _CreateUpdateNotesViewState extends State<CreateUpdateNotesView> {
  CloudNotes? _notes;
  late final FirebaseCloudStorage _notesService;
  late final TextEditingController _textController;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    _textController = TextEditingController();
    super.initState();
  }

  void _textControllerListener() async {
    final notes = _notes;
    if (notes == null) {
      return;
    }
    final text = _textController.text;
    await _notesService.updateNote(
      documentId: notes.documentId,
      text: text,
    );
  }

  void _setTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  Future<CloudNotes> createOrGetExistingNotes(BuildContext context) async {
    final widgetNotes = context.getArgument<CloudNotes>();

    if (widgetNotes != null) {
      _notes = widgetNotes;
      _textController.text = widgetNotes.text;
      return widgetNotes;
    }
    final existingNotes = _notes;
    if (existingNotes != null) {
      return existingNotes;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id;
    final newNotes = await _notesService.createNewNote(ownerUserId: userId);
    _notes = newNotes;
    return newNotes;
  }

  void _deleteNotesIfTextIsEmpty() {
    final note = _notes;
    if (_textController.text.isEmpty && note != null) {
      _notesService.deleteNote(documentId: note.documentId);
    }
  }

  void _saveNotesIfTextIsNotEmpty() async {
    final notes = _notes;
    final text = _textController.text;
    if (notes != null && text.isNotEmpty) {
      await _notesService.updateNote(
        documentId: notes.documentId,
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
        title: const Text(
          'New Notes',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final text = _textController.text;
              if (_notes == null || text.isEmpty) {
                await showCannotShareEmptyNoteDialog(context);
              } else {
                Share.share(text);
              }
            },
            icon: const Icon(Icons.share),
          )
        ],
        backgroundColor: const Color.fromARGB(255, 78, 136, 207),
      ),
      body: FutureBuilder(
          future: createOrGetExistingNotes(context),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                _setTextControllerListener();
                return TextField(
                  controller: _textController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'Start typing your notes here...',
                  ),
                );
              default:
                return const CircularProgressIndicator();
            }
          }),
    );
  }
}
