import 'package:flutter/material.dart';
import 'package:subiupressao_app/app_celular/Components/Controller.dart';
import 'package:subiupressao_app/app_celular/Components/Header.dart';
import 'package:subiupressao_app/app_celular/Consultas/AppointmentsList.dart';
import 'package:subiupressao_app/app_celular/Consultas/EditAppointment.dart';
import 'package:subiupressao_app/app_celular/Consultas/ProfileSummary.dart';

class Appointments extends StatelessWidget {
  Controller controller;

  Appointments({@required this.controller});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        size.width * 0.03,
        size.height * 0.06,
        size.width * 0.03,
        size.height * 0.015,
      ),
      child: Column(
        children: [
          Header(
            controller: controller,
            buttonFunction: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditAppointment(
                    controller: controller,
                  ),
                ),
              );
            },
          ),
          ProfileSummary(
            controller: controller,
          ),
          AppointmentsList(
            controller: controller,
          ),
        ],
      ),
    );
  }
}
