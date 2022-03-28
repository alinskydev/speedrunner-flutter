import '/core/base/model.dart';

class AuthRegister extends Model {
  @override
  Map<ModelFieldType, List> availableFields = {
    ModelFieldType.all: [
      'username',
      'email',
      'full_name',
      'phone',
      'password',
      'confirm_password',
    ],
  };

  AuthRegister([Map<String, dynamic> map = const {}]) : super(map);
}
