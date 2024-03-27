import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mynotes/service/cloud/cloud_notes.dart';
import 'package:share_plus/share_plus.dart';
import '../../utilities/dialog/delete_dialog.dart';

typedef NotesCallback = void Function(CloudNotes note);

class NoteListView extends StatelessWidget {
  final Iterable<CloudNotes> notes;
  final NotesCallback onDeleteNote;
  final NotesCallback onTap;

  const NoteListView({
    super.key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes.elementAt(index);
        return Slidable(
          key: ValueKey(note.documentId),
          startActionPane: ActionPane(
            motion: const BehindMotion(),
            children: [
              SlidableAction(
                label: "Delete",
                onPressed: (context) async {
                  final shouldDelete = await showDeleteDialog(context);
                  if (shouldDelete) {
                    onDeleteNote(note);
                  }
                },
                icon: Icons.delete,
                backgroundColor: Colors.red,
              ),
            ],
          ),
          endActionPane: ActionPane(
            motion: const BehindMotion(),
            children: [
              SlidableAction(
                label: "Share",
                onPressed: (context) async {
                  Share.share(note.text);
                },
                icon: Icons.share,
                backgroundColor: Colors.green,
              ),
              SlidableAction(
                label: "Delete",
                onPressed: (context) async {
                  final shouldDelete = await showDeleteDialog(context);
                  if (shouldDelete) {
                    onDeleteNote(note);
                  }
                },
                icon: Icons.delete,
                backgroundColor: Colors.red,
              ),
            ],
          ),
          child: Card(
            child: ListTile(
              onTap: () => onTap(note),
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
            ),
          ),
        );
      },
    );
  }
}
