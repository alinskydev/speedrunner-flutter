import '/base/model.dart';

class BlogCategory extends Model {
  @override
  Map<ModelFieldType, List> availableFields = {
    ModelFieldType.all: [
      'id',
      'name',
      'image',
    ],
    ModelFieldType.localized: [
      'name',
    ],
  };

  BlogCategory.fromMap(Map<String, dynamic> map) : super.fromMap(map);
}
