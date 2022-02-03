import 'package:flutter/widgets.dart';
import 'package:subiupressao_app/files/FileController.dart';

import 'package:subiupressao_app/files/models/user.dart';

class MedicineController extends ChangeNotifier {
  User _user;
  DateTime _dateTime;
  FileController _controller = new FileController();

  User get user => _user;
  DateTime get dateTime => _dateTime;

  void updateUser({@required User newUser}) async {
    _user = newUser;
    _controller.writeUser(newUser.name, newUser.age, newUser.medicines);

    notifyListeners();
  }

  void updateDateTime({@required DateTime newDateTime}) async {
    _dateTime = newDateTime;
    notifyListeners();
  }
}
