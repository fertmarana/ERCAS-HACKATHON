import 'package:flutter/widgets.dart';

import 'package:subiupressao_app/files/FileManager.dart';
import 'package:subiupressao_app/files/models/appointment.dart';
import 'package:subiupressao_app/files/models/medicine.dart';
import 'package:subiupressao_app/files/models/user.dart';

class FileController extends ChangeNotifier {
  User _user;

  User get user => _user;

  void readUser() async {
    final result = await FileManager().readJsonFile();

    if (result != null) {
      _user = User.fromJson(result);
    }

    notifyListeners();
  }

  void writeUser(
    String name,
    int age,
    List<Medicine> medicines,
    List<Appointment> appointments,
  ) async {
    _user = await FileManager().writeJsonFile(
      name,
      age,
      medicines,
      appointments,
    );
    notifyListeners();
  }

  void deleteUser() async {
    await FileManager().deleteJsonFile();
    notifyListeners();
  }
}
