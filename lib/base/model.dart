import '/libraries/base.dart' as base;

abstract class Model {
  abstract Map<ModelFieldType, List> availableFields;

  Map<String, dynamic> fields = {};
  Map<String, dynamic> localizedFields = {};

  Model(Map<String, dynamic> map) {
    prepare();

    fields = fields.map((key, value) {
      return MapEntry(
        key,
        map.containsKey(key) ? map[key] : value,
      );
    });

    localizedFields = localizedFields.map(
      (key, value) => MapEntry(
        key,
        map.containsKey(key) ? (map[key] != null ? map[key][base.Intl.language] : null) : value,
      ),
    );
  }

  void prepare() {
    availableFields[ModelFieldType.all] ??= [];
    availableFields[ModelFieldType.localized] ??= [];

    fields = {for (String element in availableFields[ModelFieldType.all]!) element: null};
    localizedFields = {for (String element in availableFields[ModelFieldType.localized]!) element: null};
  }

  String getValue(String field) {
    if (localizedFields.containsKey(field)) {
      return (localizedFields[field] ?? '').toString();
    } else if (fields.containsKey(field)) {
      return (fields[field] ?? '').toString();
    } else {
      throw Exception('Field $field not found');
    }
  }

  dynamic getStrictValue(String field) {
    if (localizedFields.containsKey(field)) {
      return localizedFields[field];
    } else if (fields.containsKey(field)) {
      return fields[field];
    } else {
      throw Exception('Field $field not found');
    }
  }

  void assignRelation(Model model, Model relation) {}
}

enum ModelFieldType { all, localized }
