import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:subiupressao_app/app_celular/Components/UserDataInput.dart';
import 'package:subiupressao_app/app_celular/Remedios/EditMedicine.dart';
import 'package:subiupressao_app/app_celular/Components/Controller.dart';
import 'package:subiupressao_app/files/models/user.dart';

class Header extends StatefulWidget {
  Controller controller;
  Function buttonFunction;

  Header({@required this.controller, @required this.buttonFunction});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  DateTime _dateTime;
  User _user;

  @override
  void initState() {
    _user = widget.controller.user;
    _dateTime = widget.controller.dateTime;

    widget.controller.addListener(() {
      setState(() {
        _user = widget.controller.user;
        _dateTime = widget.controller.dateTime;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          // Calendar button
          onPressed: () {
            showDatePicker(
                    context: context,
                    initialDate: _dateTime,
                    firstDate: DateTime(2010),
                    lastDate: DateTime(2200))
                .then((date) {
              widget.controller.updateDateTime(
                newDateTime: date == null ? _dateTime : date,
              );
            });
          },
          icon: const Icon(Icons.calendar_today_rounded, size: 30),
        ),
        Spacer(),
        Text(
          DateFormat("d 'de' MMMM, y", "pt_BR").format(_dateTime).toUpperCase(),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Spacer(),
        IconButton(
          // Add medicine button
          onPressed: widget.buttonFunction, 
          icon: const Icon(Icons.add_box, size: 40),
        ),
      ],
    );
  }
}
