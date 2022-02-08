import 'package:flutter/widgets.dart';
import 'package:subiupressao_app/app_celular/Components/ProfileSummary.dart'
    as Profile;
import 'package:subiupressao_app/app_celular/Components/Controller.dart';
import 'package:subiupressao_app/files/models/user.dart';

class ProfileSummary extends StatefulWidget {
  final Controller controller;
  final bool connected;

  ProfileSummary({@required this.controller, @required this.connected});

  @override
  State<StatefulWidget> createState() => _ProfileSummary();
}

class _ProfileSummary extends State<ProfileSummary> {
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
    return Profile.ProfileSummary(
      children: [
        Text("Olá, ${_user.name}!", style: TextStyle(fontSize: 16)),
        SizedBox(height: 5),
        Text("Atualmente, você tem", style: TextStyle(fontSize: 16)),
        SizedBox(height: 3),
        Text(
          "${widget.connected ? "um" : "zero"} dispositivo conectado",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
