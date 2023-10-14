class CloudStorageException implements Exception {
  const CloudStorageException();
}

//C in CRUD
class CouldNotCreateNoteException extends CloudStorageException {}

//R in CRUD
class CouldNotGetAllNotesException extends CloudStorageException {}

class CouldNotGetAllTodosException extends CloudStorageException {}

//U in CRUD
class CouldNotUpdateNoteException extends CloudStorageException {}

class CouldNotUpdateTodoException extends CloudStorageException {}

//D in CRUD
class CouldNotDeleteNoteException extends CloudStorageException {}

class CouldNotDeleteTodoException extends CloudStorageException {}
