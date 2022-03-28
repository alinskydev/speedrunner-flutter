// ignore_for_file: prefer_for_elements_to_map_fromiterable

import '/libraries/base.dart' as base;

enum ModelFieldType { all, localized, relational }

abstract class Model {
  abstract Map<ModelFieldType, List> availableFields;

  Map<ModelFieldType, Map<String, dynamic>> fields = {};

  Model(Map<String, dynamic> map) {
    fields = {
      ModelFieldType.all: Map.fromIterable(
        availableFields[ModelFieldType.all] ?? [],
        key: (element) => element,
        value: (element) => map[element],
      ),
      ModelFieldType.localized: Map.fromIterable(
        availableFields[ModelFieldType.localized] ?? [],
        key: (element) => element,
        value: (element) => map[element] != null ? map[element][base.Singletons.intl.language] : null,
      ),
      ModelFieldType.relational: Map.fromIterable(
        availableFields[ModelFieldType.relational] ?? [],
        key: (element) => element,
        value: (element) => map[element],
      ),
    };
  }

  dynamic getValue(String field, {bool asString = true}) {
    dynamic value;

    if (asString && fields[ModelFieldType.localized]!.containsKey(field)) {
      value = fields[ModelFieldType.localized]![field];
    } else {
      value = fields[ModelFieldType.all]![field];
    }

    return asString ? (value ?? '').toString() : value;
  }
}
