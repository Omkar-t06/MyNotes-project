import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynotes/service/cloud/cloud_storage_constants.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
class CloudTodos {
  final String documentId;
  final String ownerUserId;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime dueDate;

  const CloudTodos({
    required this.documentId,
    required this.ownerUserId,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.dueDate,
  });

  CloudTodos.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        title = snapshot.data()[titleFieldName] as String,
        description = snapshot.data()[descriptionFieldName] as String,
        isCompleted = snapshot.data()[isCompletedFieldName] as bool,
        dueDate = snapshot.data()[dueDateFieldName].toDate() as DateTime;
}
