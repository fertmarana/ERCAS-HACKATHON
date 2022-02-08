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
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 40, 10, 10),
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
          ProfileSummary(controller: controller,),
          AppointmentsList(controller: controller,),
        ],
      ),
    );
  }
}
