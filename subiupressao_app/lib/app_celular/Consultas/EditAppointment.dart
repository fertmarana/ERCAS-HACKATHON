import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:subiupressao_app/app_celular/Components/Controller.dart';
import 'package:subiupressao_app/app_celular/Components/UserDataInput.dart';
import 'package:subiupressao_app/files/models/appointment.dart';
import 'package:subiupressao_app/files/models/user.dart';

class EditAppointment extends StatefulWidget {
  final Appointment element;
  final Controller controller;

  EditAppointment({@required this.controller, this.element});

  @override
  State<EditAppointment> createState() => _EditAppointmentState();
}

class _EditAppointmentState extends State<EditAppointment> {
  final TextEditingController doctorController = TextEditingController();
  final TextEditingController specialityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    User user = widget.controller.user;

    List<Widget> children = [
      SizedBox(height: size.height * 0.05),
      Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.close),
          ),
          Spacer(),
          Text(
            this.widget.element == null ? "Nova Consulta" : "Editar Consulta",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Spacer(),
          IconButton(
            onPressed: () {
              int index = user.appointments.length;

              if (widget.element != null) {
                index = user.appointments.indexOf(widget.element);
                user.appointments.remove(widget.element);
              }

              user.appointments.insert(
                index,
                Appointment(
                    doctor: doctorController.text,
                    speciality: specialityController.text,
                    date: widget.controller.dateTime),
              );
              widget.controller.updateUser(newUser: user);

              Navigator.of(context).pop();
            },
            icon: Icon(Icons.check),
          )
        ],
      ),
      SizedBox(height: size.height * 0.005),
      Icon(Icons.assignment_ind, size: size.height * 0.1),
      SizedBox(height: size.height * 0.03),
      UserDataInput(
        controller: doctorController,
        fieldName: "Nome do Médico",
        hintString: "Médico",
      ),
      SizedBox(height: size.height * 0.03),
      UserDataInput(
        controller: specialityController,
        fieldName: "Especialidade do Médico",
        hintString: "Especialidade",
      ),
      SizedBox(height: size.height * 0.03),
      UserDataInput(
        controller: TextEditingController(
            text: DateFormat("dd/MM/yyyy").format(widget.controller.dateTime)),
        enabled: false,
        fieldName: "Data da Consulta",
      ),
    ];

    if (widget.element != null) {
      children.add(SizedBox(
        height: size.height * 0.03,
      ));
      children.add(
        ElevatedButton(
          onPressed: () {
            user.appointments.remove(widget.element);
            widget.controller.updateUser(newUser: user);
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
