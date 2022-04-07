import 'package:flutter/widgets.dart';
import 'package:subiupressao_app/files/FileController.dart';
import 'package:subiupressao_app/files/models/appointment.dart';
import 'package:subiupressao_app/files/models/medicine.dart';

import 'package:subiupressao_app/files/models/user.dart';

class Controller extends ChangeNotifier {
  User _user;
  DateTime _dateTime;
  FileController _controller = new FileController();
  List<Medicine> _todayMedicines = [];
  List<Appointment> _todayAppointments = [];

  User get user => _user;
  DateTime get dateTime => _dateTime;
  List<Medicine> get todayMedicines => _todayMedicines;
  List<Appointment> get todayAppointments => _todayAppointments;

  void _updateTodayAppointments() {
    DateTime today;

    today = DateTime(
      _dateTime.year,
      _dateTime.month,
      _dateTime.day,
    );

    _todayAppointments = [];
    _user.appointments.forEach((element) {
      if (element.date.isAtSameMomentAs(today)) {
        _todayAppointments.add(element);
      }
    });
  }

  void _updateTodayMedicines() {
    DateTime today;

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
  }

  void updateUser({@required User newUser}) async {
    var oldUser = _user;

    _user = newUser;
    _controller.writeUser(
      newUser.name,
      newUser.age,
      newUser.medicines,
      newUser.appointments,
    );

    _updateTodayMedicines();
    _updateTodayAppointments();

    notifyListeners();
  }

  void updateDateTime({@required DateTime newDateTime}) async {
    if (_dateTime != newDateTime) {
      _dateTime = newDateTime;

      _updateTodayAppointments();
      _updateTodayMedicines();

      notifyListeners();
    }
  }
}
