import 'package:flutter/widgets.dart';
import 'package:subiupressao_app/files/FileController.dart';
import 'package:subiupressao_app/files/models/medicine.dart';

import 'package:subiupressao_app/files/models/user.dart';

class Controller extends ChangeNotifier {
  User _user;
  DateTime _dateTime;
  FileController _controller = new FileController();
  List<Medicine> _todayMedicines = [];

  User get user => _user;
  DateTime get dateTime => _dateTime;
  List<Medicine> get todayMedicines => _todayMedicines;

  void updateUser({@required User newUser}) async {
    _user = newUser;
    _controller.writeUser(
      newUser.name,
      newUser.age,
      newUser.medicines,
      newUser.appointments,
    );

    notifyListeners();
  }

  void updateDateTime({@required DateTime newDateTime}) async {
    DateTime today;

    if (_dateTime != newDateTime) {
      _dateTime = newDateTime;

      today = DateTime(
        _dateTime.year,
        _dateTime.month,
        _dateTime.day,
      );

      _todayMedicines = [];
      _user.medicines.forEach((element) {
        if (element.start.subtract(Duration(days: 1)).isBefore(today) &&
            element.end.add(Duration(days: 1)).isAfter(today)) {
          _todayMedicines.add(element);
        }
      });

      notifyListeners();
    }
  }
}
