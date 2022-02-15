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
        map.containsKey(key) ? map[key]['en'] : value,
      ),
    );
  }

  void prepare() {
    availableFields[ModelFieldType.all] ??= [];
    availableFields[ModelFieldType.localized] ??= [];

    fields = {for (String element in availableFields[ModelFieldType.all]!) element: null};
    localizedFields = {for (String element in availableFields[ModelFieldType.localized]!) element: null};
  }

  dynamic getField(String key) {
    if (fields.containsKey(key)) {
      return fields[key];
    } else {
      throw Exception('Key $key not found');
    }
  }

  void setField(String key, dynamic value) {
    if (fields.containsKey(key)) {
      fields[key] = value;
    } else {
      throw Exception('Key $key not found');
    }
  }

  void assignRelation(Model model, Model relation) {}
}

enum ModelFieldType { all, localized }
