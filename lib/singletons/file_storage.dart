import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileStorage {
  late final String _rootDir;

  FileStorage._init();

  static Future<FileStorage> init() async {
    FileStorage instance = FileStorage._init();
    instance._rootDir = (await getApplicationDocumentsDirectory()).path;

    return instance;
  }

  Future<String?> getFileContent(String name) async {
    File file = File('$_rootDir/$name');

    return (await file.exists()) ? file.readAsString() : Future.value(null);
  }

  Future<File> setFileContent(String name, String content) {
    File file = File('$_rootDir/$name');

    return file.writeAsString(content);
  }
}
