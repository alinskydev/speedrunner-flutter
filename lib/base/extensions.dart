part of 'bootstrap.dart';

extension MapExtension on Map {
  Object? getValueFromPath(String path, [Object? map]) {
    map ??= this;
    if (map is! Map<String, dynamic>) return null;

    int index = path.indexOf('.');
    if (index < 0) return map[path];

    return getValueFromPath(path.substring(index + 1), map[path.substring(0, index)]);
  }
}
