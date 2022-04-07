import 'package:flutter/widgets.dart';
import 'package:subiupressao_app/app_celular/Components/ProfileSummary.dart'
    as Profile;
import 'package:subiupressao_app/app_celular/Components/Controller.dart';
import 'package:subiupressao_app/files/models/appointment.dart';
import 'package:subiupressao_app/files/models/user.dart';

class ProfileSummary extends StatefulWidget {
  Controller controller;

  ProfileSummary({@required this.controller});

  @override
  State<ProfileSummary> createState() => _ProfileSummaryState();
}

class _ProfileSummaryState extends State<ProfileSummary> {
  User _user;
  List<Appointment> _todayAppointments;

  @override
  void initState() {
    _user = widget.controller.user;
    _todayAppointments = widget.controller.todayAppointments;
    widget.controller.addListener(() {
      setState(() {
        _todayAppointments = widget.controller.todayAppointments;
        _user = widget.controller.user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Profile.ProfileSummary(
      children: [
        Text("Olá, ${_user.name}!", style: TextStyle(fontSize: 16)),
        SizedBox(height: size.height * 0.003),
        Text("Hoje você tem que ir em", style: TextStyle(fontSize: 16)),
        SizedBox(height: size.height * 0.007),
        Text(
          "${_todayAppointments.length} consulta" +
              "${_todayAppointments.length > 1 ? "s" : ""}",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
