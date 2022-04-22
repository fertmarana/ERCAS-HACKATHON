import 'dart:io';
import 'dart:convert';

import 'package:path_provider/path_provider.dart';
import 'package:subiupressao_app/files/models/user.dart';

class FileManager {
  static FileManager _instance;

  FileManager._internal() {
    _instance = this;
  }

  factory FileManager() => _instance ?? FileManager._internal();

  Future<String> get _directoryPath async {
    Directory directory;

    directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _jsonFile async {
    final String path = await _directoryPath;
    return File('$path/user.json');
  }

  Future<Map<String, dynamic>> readJsonFile() async {
    String fileContent = '';

    File file = await _jsonFile;

    if (await file.exists()) {
      try {
        fileContent = await file.readAsString();
        return json.decode(fileContent);
      } catch (e) {
        // print("Something went wrong!");
      }
    }

    return null;
  }

  Future<User> writeJsonFile(User user) async {
    File file = await _jsonFile;

    await file.writeAsString(jsonEncode(user.copyUser()));

    return user;
  }

  Future<int> deleteJsonFile() async {
    final File file = await _jsonFile;

    try {
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      return -1;
    }

    return 0;
  }
}
