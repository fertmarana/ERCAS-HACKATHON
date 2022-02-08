import 'package:flutter/material.dart';
import 'package:subiupressao_app/app_celular/Remedios/EditMedicine.dart';
import 'package:subiupressao_app/app_celular/Components/Controller.dart';

import 'package:subiupressao_app/files/models/user.dart';

class MedicinesList extends StatefulWidget {
  Controller controller;

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
                  SizedBox(width: size.width * 0.04),
                  Container(
                    child: Text(element.name),
                    constraints: BoxConstraints(
                      maxWidth: size.width * 0.3,
                      minWidth: size.width * 0.3,
                    ),
                  ),
                  SizedBox(width: size.width * 0.05),
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
    Size size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.fromLTRB(
        size.width * 0.03,
        size.height * 0.0,
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
