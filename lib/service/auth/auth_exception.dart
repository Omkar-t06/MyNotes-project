//login exception
class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

//register exception
class WeakPasswordAuthExceptions implements Exception {}

class EmailAlreadyInUseAuthExceptions implements Exception {}

class InvalidEmailAuthExceptions implements Exception {}

//Generic exceptions
class GenericAuthExceptions implements Exception {}

class UserNotLoggedInAuthExceptions implements Exception {}
