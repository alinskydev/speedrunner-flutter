enum AppExceptionButtonActions { goHome, refresh }

abstract class AppException implements Exception {
  abstract int code;
  abstract String label;
  abstract String image;
  abstract AppExceptionButtonActions buttonRoute;
}

class AppExceptionNoConnection extends AppException {
  @override
  int code = -1;
  @override
  String label = 'No connection';
  @override
  String image = 'assets/images/errors/no_connection.png';
  @override
  AppExceptionButtonActions buttonRoute = AppExceptionButtonActions.refresh;
}

class AppExceptionNotAllowed extends AppException {
  @override
  int code = 403;
  @override
  String label = 'Access denied';
  @override
  String image = 'assets/images/errors/403.png';
  @override
  AppExceptionButtonActions buttonRoute = AppExceptionButtonActions.goHome;
}

class AppExceptionInternalError extends AppException {
  @override
  int code = 500;
  @override
  String label = 'Internal error';
  @override
  String image = 'assets/images/errors/500.png';
  @override
  AppExceptionButtonActions buttonRoute = AppExceptionButtonActions.goHome;
}
