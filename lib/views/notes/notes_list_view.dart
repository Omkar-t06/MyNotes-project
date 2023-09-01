import 'package:flutter/material.dart';
import 'package:mynotes/service/crud/note_service.dart';

import '../../utilities/dialog/delete_dialog.dart';

typedef DeleteNotesCallback = void Function(DatabaseNotes note);

class NoteListView extends StatelessWidget {
  final List<DatabaseNotes> notes;
  final DeleteNotesCallback onDeleteNote;

  const NoteListView({
    super.key,
    required this.notes,
    required this.onDeleteNote,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return ListTile(
          title: Text(
            note.text,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            onPressed: () async {
              final shouldDelete = await showDeleteDialog(context);
              if (shouldDelete) {
                onDeleteNote(note);
              }
            },
            icon: const Icon(Icons.delete),
          ),
        );
      },
    );
  }
}
