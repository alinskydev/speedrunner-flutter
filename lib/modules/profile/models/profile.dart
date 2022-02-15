import '/base/model.dart';

class Profile extends Model {
  @override
  Map<ModelFieldType, List> availableFields = {
    ModelFieldType.all: [
      'full_name',
      'phone',
      'address',
      'image',
      'new_password',
      'confirm_password',
    ],
  };

  Profile([Map<String, dynamic> map = const {}]) : super(map);
}
