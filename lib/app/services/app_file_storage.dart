import 'dart:io';

import 'package:path_provider/path_provider.dart';

class AppFileStorage {
  Future<String> rootDir() async {
    var dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<File> getFile(String name) async {
    var dir = await rootDir();
    return File('$dir/$name');
  }

  Future<String?> getFileContent(String name) async {
    var file = await getFile(name);

    return file.exists().then((isExists) {
      return isExists ? file.readAsString() : Future.value(null);
    });
  }

  Future<File> setFileContent(String name, String content) async {
    var file = await getFile(name);
    return file.writeAsString(content);
  }
}
