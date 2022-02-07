import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'package:subiupressao_app/app_celular/Components/Controller.dart';
import 'package:subiupressao_app/app_celular/Components/UserDataInput.dart';
import 'package:subiupressao_app/files/models/appointment.dart';
import 'package:subiupressao_app/files/models/user.dart';

class EditAppointment extends StatelessWidget {
  final Appointment element;
  final Controller controller;
  final TextEditingController doctorController = new TextEditingController();
  final TextEditingController specialityController = TextEditingController();

  EditAppointment({@required this.controller, this.element});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    User user = controller.user;

    List<Widget> children = [
      SizedBox(height: size.height * 0.1),
      Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.close),
          ),
          Spacer(),
          Text(this.element == null ? "Nova Consulta" : "Editar Consulta"),
          Spacer(),
          IconButton(
            onPressed: () {
              user.appointments.add(
                Appointment(
                    doctor: doctorController.text,
                    speciality: specialityController.text,
                    date: controller.dateTime),
              );
              controller.updateUser(newUser: user);
            },
            icon: Icon(Icons.check),
          )
        ],
      ),
      SizedBox(height: size.height * 0.05),
      Icon(Icons.assignment_ind_outlined),
      SizedBox(height: size.height * 0.05),
      UserDataInput(
        controller: doctorController,
        fieldName: "Nome do Médico",
        hintString: "Médico",
      ),
      SizedBox(height: size.height * 0.05),
      UserDataInput(
        controller: specialityController,
        fieldName: "Especialidade do Médico",
        hintString: "Especialidade",
      ),
      SizedBox(height: size.height * 0.05),
      element == null
          ? UserDataInput(
              controller: TextEditingController(
                  text: DateFormat("dd/MM/yyyy").format(controller.dateTime)),
              enabled: false,
              fieldName: "Data da Consulta",
            )
          : showDatePicker(
              context: context,
              initialDate: controller.dateTime,
              firstDate: DateTime(2010),
              lastDate: DateTime(2200),
            ),
    ];

    if (element != null) {
      children.add(
        ElevatedButton(
          onPressed: () {
            user.medicines.remove(element);
            controller.updateUser(newUser: user);
            Navigator.of(context).pop();
          },
          child: Text("Deletar Consulta"),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: children,
        ),
      ),
    );
  }
}
