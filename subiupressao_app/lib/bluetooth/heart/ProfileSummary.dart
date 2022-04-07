import 'package:flutter/widgets.dart';
import 'package:subiupressao_app/app_celular/Components/ProfileSummary.dart'
as Profile;
import 'package:subiupressao_app/app_celular/Components/Controller.dart';
import 'package:subiupressao_app/files/models/user.dart';

class ProfileSummary extends StatefulWidget {
 // final Controller controller;
  final int heartRate;
  ProfileSummary({@required this.heartRate});
 // ProfileSummary({@required this.controller, @required this.heartRate});

  @override
  State<ProfileSummary> createState() => _ProfileSummaryState();
}

class _ProfileSummaryState extends State<ProfileSummary> {
  User _user;
 // int heartRate;
  @override
  void initState() {
    /*
    _user = widget.controller.user;

    widget.controller.addListener(() {
      setState(() {
        _user = widget.controller.user;
      });
    });*/
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Profile.ProfileSummary(
      children: [
        //Text("Olá, ${_user.name}!", style: TextStyle(fontSize: 16)),
        SizedBox(height: size.height * 0.003),
        Text("Sua frequência cardíaca é", style: TextStyle(fontSize: 16)),
        SizedBox(height: size.height * 0.007),
        Text(
          "${widget.heartRate == -1? "-": widget.heartRate} bpm",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}