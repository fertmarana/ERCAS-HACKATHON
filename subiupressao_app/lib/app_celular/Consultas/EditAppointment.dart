import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  TextEditingController _doctorController;
  TextEditingController _specialityController;
  var horizontalOffset = 0.05;
  DateTime dateTime;

  @override
  void initState() {
    _doctorController = new TextEditingController(
      text: widget.element == null ? "" : widget.element.doctor,
    );

    _specialityController = new TextEditingController(
      text: widget.element == null ? "" : widget.element.speciality,
    );

    dateTime = widget.element == null
        ? widget.controller.dateTime
        : widget.element.date;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // print(size.toString());

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
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
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
                  doctor: _doctorController.text,
                  speciality: _specialityController.text,
                  date: dateTime,
                ),
              );

              widget.controller.updateUser(newUser: user);

              Navigator.of(context).pop();
            },
            icon: Icon(Icons.check),
          )
        ],
      ),
      SizedBox(height: size.height * 0.01),
      Icon(Icons.assignment_ind_outlined, size: 70),
      SizedBox(height: size.height * 0.03),
      UserDataInput(
        controller: _doctorController,
        fieldName: "Nome do Médico",
        hintString: "Médico",
        spacerInterval: horizontalOffset,
      ),
      SizedBox(height: size.height * 0.03),
      UserDataInput(
        controller: _specialityController,
        fieldName: "Especialidade do Médico",
        hintString: "Especialidade",
        spacerInterval: horizontalOffset,
      ),
      SizedBox(height: size.height * 0.03),
      Row(
        children: [
          SizedBox(width: horizontalOffset * size.width),
          Text(
            "Qual a data da consulta?",
            style: TextStyle(fontSize: 16),
          ),
          Spacer()
        ],
      ),
      Row(
        children: [
          SizedBox(width: size.width * horizontalOffset),
          TextField(
            enabled: false,
            decoration: InputDecoration(
              constraints: BoxConstraints(maxWidth: size.width * 0.75),
              border: OutlineInputBorder(),
              hintText: DateFormat("dd/MM/yyyy").format(dateTime),
            ),
          ),
          Spacer(),
          IconButton(
            onPressed: () {
              showDatePicker(
                      context: context,
                      initialDate: dateTime,
                      firstDate: DateTime(2010),
                      lastDate: DateTime(2200))
                  .then((date) {
                setState(() {
                  dateTime = (date == null ? dateTime : date);
                });
              });
            },
            icon: const Icon(
              Icons.calendar_today_rounded,
              size: 25,
            ),
            iconSize: size.width * 0.05,
          ),
          SizedBox(width: size.width * horizontalOffset),
        ],
      ),
      SizedBox(height: size.height * 0.015,)
    ];

    if (widget.element != null) {
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
