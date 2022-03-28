import '/core/base/model.dart';

class AuthResetPasswordRequest extends Model {
  @override
  Map<ModelFieldType, List> availableFields = {
    ModelFieldType.all: [
      'email',
    ],
  };

  AuthResetPasswordRequest([Map<String, dynamic> map = const {}]) : super(map);
}
