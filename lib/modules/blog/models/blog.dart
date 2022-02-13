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

  Blog.fromMap(Map<String, dynamic> map) : super.fromMap(map) {
    if (fields['category'] != null) category = models.BlogCategory.fromMap(fields['category']);
  }
}
