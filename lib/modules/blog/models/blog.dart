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
      'category',
      'short_description',
      'image',
      'images',
      'published_at',
    ],
    ModelFieldType.localized: [
      'name',
      'short_description',
    ],
  };

  models.BlogCategory? category;

  Blog([Map<String, dynamic> map = const {}]) : super(map) {
    if (fields['category'] != null) category = models.BlogCategory(fields['category']);
  }
}
