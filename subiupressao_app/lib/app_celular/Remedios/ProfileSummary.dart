import 'package:flutter/widgets.dart';
import 'package:subiupressao_app/app_celular/Components/ProfileSummary.dart'
    as Profile;
import 'package:subiupressao_app/app_celular/Remedios/RemediosController.dart';
import 'package:subiupressao_app/files/models/user.dart';

class ProfileSummary extends StatefulWidget {
  MedicineController controller;

  ProfileSummary({@required this.controller});

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
        SizedBox(height: 2),
        Text("Hoje você tem de tomar", style: TextStyle(fontSize: 16)),
        SizedBox(height: 5),
        Text(
          "${_user.medicines.length} remédio" +
              "${_user.medicines.length > 1 ? "s" : ""}",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
