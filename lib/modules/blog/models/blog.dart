import '/base/model.dart';

import '/libraries/models.dart' as models;

class Blog extends Model {
  @override
  Map<ModelFieldType, List> availableFields = {
    ModelFieldType.all: [
      'id',
      'name',
      'slug',
      'category_id',
      'short_description',
      'image',
      'images',
      'published_at',
    ],
    ModelFieldType.localized: [
      'name',
      'short_description',
    ],
    ModelFieldType.relational: [
      'category',
    ],
  };

  models.BlogCategory? category;

  Blog([Map<String, dynamic> map = const {}]) : super(map) {
    Map<String, dynamic> relations = fields[ModelFieldType.relational]!;

    if (relations['category'] != null) category = models.BlogCategory(relations['category']);
  }
}
