import 'package:flutter/widgets.dart';
import 'package:subiupressao_app/app_celular/Components/ProfileSummary.dart'
    as Profile;
import 'package:subiupressao_app/app_celular/Components/Controller.dart';
import 'package:subiupressao_app/files/models/user.dart';

class ProfileSummary extends StatefulWidget {
  Controller controller;

  ProfileSummary({this.controller});

  @override
  State<StatefulWidget> createState() => _ProfileSummaryState();
}

class _ProfileSummaryState extends State<ProfileSummary> {
  User _user;

  @override
  void initState() {
    _user = widget.controller.user;

    widget.controller.addListener(() {
      setState(() {
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
        Text("Sua pressão média é", style: TextStyle(fontSize: 16)),
        SizedBox(height: size.height * 0.003),
        Text(
          "${_user.bloodPressure.toString()} (${_user.cardiacSituation})",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
