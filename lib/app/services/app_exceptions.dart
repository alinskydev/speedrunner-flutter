enum AppExceptionButtonRoutes { home, refresh }

abstract class AppException implements Exception {
  abstract int code;
  abstract String label;
  abstract String image;
  abstract AppExceptionButtonRoutes buttonRoute;
}

class AppExceptionNoConnection extends AppException {
  @override
  int code = -1;
  @override
  String label = 'No connection';
  @override
  String image = 'no_connection';
  @override
  AppExceptionButtonRoutes buttonRoute = AppExceptionButtonRoutes.refresh;
}

class AppExceptionNotAllowed extends AppException {
  @override
  int code = 403;
  @override
  String label = '403';
  @override
  String image = '403';
  @override
  AppExceptionButtonRoutes buttonRoute = AppExceptionButtonRoutes.home;
}

class AppExceptionInternalError extends AppException {
  @override
  int code = 500;
  @override
  String label = '500';
  @override
  String image = '500';
  @override
  AppExceptionButtonRoutes buttonRoute = AppExceptionButtonRoutes.home;
}
