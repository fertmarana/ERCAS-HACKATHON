import 'package:flutter/material.dart';
import 'package:subiupressao_app/app_celular/Consultas/EditAppointment.dart';
import 'package:subiupressao_app/app_celular/Components/Controller.dart';

import 'package:subiupressao_app/files/models/user.dart';

class AppointmentsList extends StatefulWidget {
  Controller controller;

  AppointmentsList({@required this.controller});

  @override
  _AppointmentsList createState() => _AppointmentsList();
}

class _AppointmentsList extends State<AppointmentsList> {
  List<Widget> medicineCards = [];
  User _user;

  List<Widget> createMedicineCards() {
    Size size = MediaQueryData.fromWindow(WidgetsBinding.instance.window).size;
    List<Widget> newCards = [];

    _user.appointments.forEach((element) {
      newCards.add(
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  style: BorderStyle.solid,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Row(
                children: [
                  SizedBox(width: size.width * 0.04),
                  Container(
                    child: Text(element.doctor),
                    constraints: BoxConstraints(
                      maxWidth: size.width * 0.2,
                      minWidth: size.width * 0.2,
                    ),
                  ),
                  SizedBox(width: size.width * 0.05),
                  Text(
                    "${element.speciality}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditAppointment(
                              controller: widget.controller,
                              element: element,
                            ),
                          ),
                        );
                      },
                      icon: Icon(Icons.edit)),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.02),
          ],
        ),
      );
    });

    return newCards;
  }

  @override
  void initState() {
    _user = widget.controller.user;

    widget.controller.addListener(() {
      setState(() {
        _user = widget.controller.user;
        medicineCards = createMedicineCards();
      });
    });

    medicineCards = createMedicineCards();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.fromLTRB(
        size.width * 0.03,
        size.height * 0,
        size.width * 0.03,
        size.height * 0.03,
      ),
      child: ListView(
        children: medicineCards,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
      ),
    );
  }
}
