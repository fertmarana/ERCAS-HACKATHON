import 'dart:io';
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:subiupressao_app/files/models/appointment.dart';
import 'package:subiupressao_app/files/models/medicine.dart';
import 'package:subiupressao_app/files/models/user.dart';

class FileManager {
  static FileManager _instance;

  FileManager._internal() {
    _instance = this;
  }

  factory FileManager() => _instance ?? FileManager._internal();

  Future<String> get _directoryPath async {
    Directory directory = await getApplicationDocumentsDirectory();
    // TODO: Check for OS and use other getApplicationDocumentsDirectory if on iOS
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
        print("Something went wrong!");
      }
    }

    return null;
  }

  Future<User> writeJsonFile(
    String name,
    int age,
    List<Medicine> medicines,
    List<Appointment> appointments,
  ) async {
    final User user = User(name, age, medicines, appointments);
    File file = await _jsonFile;

    await file.writeAsString(json.encode(user));

    return user;
  }

  Future<int> deleteJsonFile() async {
    try {
      final File file = await _jsonFile;
      await file.delete();
    } catch (e) {
      print(e);
      return -1;
    }

    return 0;
  }
}
