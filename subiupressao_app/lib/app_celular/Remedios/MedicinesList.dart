import 'package:flutter/material.dart';
import 'package:subiupressao_app/app_celular/Remedios/EditMedicine.dart';
import 'package:subiupressao_app/app_celular/Remedios/RemediosController.dart';
import 'dart:async';

import 'package:subiupressao_app/files/models/user.dart';

class MedicinesList extends StatefulWidget {
  MedicineController controller;

  MedicinesList({@required this.controller});

  @override
  _MedicinesList createState() => _MedicinesList();
}

class _MedicinesList extends State<MedicinesList> {
  List<Widget> medicineCards = [];
  DateTime _dateTime;
  User _user;

  List<Widget> createMedicineCards() {
    Size size = MediaQueryData.fromWindow(WidgetsBinding.instance.window).size;
    List<Widget> newCards = [];

    _user.medicines.forEach((element) {
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
                  SizedBox(width: 15),
                  Container(
                    child: Text(element.name),
                    constraints: BoxConstraints(
                      maxWidth: size.width * 0.3,
                      minWidth: size.width * 0.3,
                    ),
                  ),
                  SizedBox(width: 20),
                  Text(
                    "${element.quantity} comprimido" +
                        "${element.quantity > 1 ? "s" : ""}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditMedicine(
                                    dateTime: _dateTime,
                                    controller: widget.controller,
                                    deleteButton: true,
                                    element: element,
                                  )),
                        );
                      },
                      icon: Icon(Icons.edit)),
                ],
              ),
            ),
            SizedBox(height: 15),
          ],
        ),
      );
    });

    return newCards;
  }

  @override
  void initState() {
    _user = widget.controller.user;
    _dateTime = widget.controller.dateTime;

    widget.controller.addListener(() {
      setState(() {
        _user = widget.controller.user;
        _dateTime = widget.controller.dateTime;
        medicineCards = createMedicineCards();
      });
    });

    medicineCards = createMedicineCards();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
      child: ListView(
        children: medicineCards,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
      ),
    );
  }
}
