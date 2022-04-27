import 'package:flutter/widgets.dart';

import 'package:subiupressao_app/files/FileManager.dart';
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

  void writeUser(User newUser) async {
    _user = await FileManager().writeJsonFile(newUser);
    notifyListeners();
  }

  void deleteUser() async {
    await FileManager().deleteJsonFile();
    notifyListeners();
  }
}
