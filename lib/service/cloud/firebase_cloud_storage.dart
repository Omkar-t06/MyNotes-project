import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynotes/service/cloud/cloud_notes.dart';
import 'package:mynotes/service/cloud/cloud_storage_constants.dart';
import 'package:mynotes/service/cloud/cloud_storage_exceptions.dart';
import 'package:mynotes/service/cloud/cloud_todos.dart';

class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection('notes');
  final todos = FirebaseFirestore.instance.collection('todos');

  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }

  Future<void> deleteTodo({required String documentId}) async {
    try {
      await todos.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteTodoException();
    }
  }

  Future<void> updateNote({
    required String documentId,
    required String text,
  }) async {
    try {
      await notes.doc(documentId).update({textFieldName: text});
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  Future<void> updateTodo({
    required String documentId,
    required String title,
    String? description,
    DateTime? dueDate,
    required bool isComplete,
  }) async {
    try {
      await todos.doc(documentId).update({
        titleFieldName: title,
        descriptionFieldName: description,
        dueDateFieldName: dueDate != null ? Timestamp.fromDate(dueDate) : null,
        isCompletedFieldName: isComplete
      });
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  Stream<Iterable<CloudNotes>> allNotes({required String ownerUserId}) =>
      notes.snapshots().map((event) => event.docs
          .map((doc) => CloudNotes.fromSnapshot(doc))
          .where((note) => note.ownerUserId == ownerUserId));

  Stream<Iterable<CloudTodos>> allTodos({required String ownerUsedId}) =>
      todos.snapshots().map((event) => event.docs
          .map((doc) => CloudTodos.fromSnapshot(doc))
          .where((todo) => todo.ownerUserId == ownerUsedId));

  Future<Iterable<CloudNotes>> getNotes({required String ownerUserId}) async {
    try {
      return await notes
          .where(
            ownerUserIdFieldName,
            isEqualTo: ownerUserId,
          )
          .get()
          .then(
            (value) => value.docs.map(
              (doc) => CloudNotes.fromSnapshot(doc),
            ),
          );
    } catch (e) {
      throw CouldNotGetAllNotesException();
    }
  }

  Future<Iterable<CloudTodos>> getTodos({required String ownerUserId}) async {
    try {
      return await todos
          .where(
            ownerUserIdFieldName,
            isEqualTo: ownerUserId,
          )
          .get()
          .then(
            (value) => value.docs.map(
              (doc) => CloudTodos.fromSnapshot(doc),
            ),
          );
    } catch (e) {
      throw CouldNotGetAllTodosException();
    }
  }

  Future<CloudNotes> createNewNote({required String ownerUserId}) async {
    final document = await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: '',
    });
    final fetchedNotes = await document.get();
    return CloudNotes(
      documentId: fetchedNotes.id,
      ownerUserId: ownerUserId,
      text: '',
    );
  }

  Future<CloudTodos> createNewTodo({required String ownerUserId}) async {
    final document = await todos.add({
      ownerUserIdFieldName: ownerUserId,
      descriptionFieldName: '',
      isCompletedFieldName: false,
      titleFieldName: '',
      dueDateFieldName: Timestamp.now(),
    });
    final fetchedTodos = await document.get();
    return CloudTodos(
      documentId: fetchedTodos.id,
      ownerUserId: ownerUserId,
      title: fetchedTodos.data()?[titleFieldName] as String,
      description: fetchedTodos.data()?[descriptionFieldName] as String?,
      isCompleted: fetchedTodos.data()?[isCompletedFieldName] as bool,
      dueDate: fetchedTodos.data()?[dueDateFieldName] != null
          ? (fetchedTodos.data()?[dueDateFieldName] as Timestamp).toDate()
          : null,
    );
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}
