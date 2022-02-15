import '/base/model.dart';

class AuthLogin extends Model {
  @override
  Map<ModelFieldType, List> availableFields = {
    ModelFieldType.all: [
      'username',
      'password',
    ],
  };

  AuthLogin([Map<String, dynamic> map = const {}]) : super(map);
}
