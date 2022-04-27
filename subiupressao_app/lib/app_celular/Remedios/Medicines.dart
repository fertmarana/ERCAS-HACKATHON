import 'package:flutter/material.dart';

import 'package:subiupressao_app/app_celular/Components/Header.dart';
import 'package:subiupressao_app/app_celular/Remedios/EditMedicine.dart';
import 'package:subiupressao_app/app_celular/Remedios/MedicinesList.dart';
import 'package:subiupressao_app/app_celular/Remedios/ProfileSummary.dart';
import 'package:subiupressao_app/app_celular/Components/Controller.dart';

// TODO: usar página de remédios para marcar os remédios já tomados no dia
// Ajuda no dia-a-dia de quem tem que tomar muitos remédios e pode esquecer

class Medicines extends StatefulWidget {
  Controller controller;

  Medicines({@required this.controller});

  @override
  State<Medicines> createState() => _MedicinesState();
}

class _MedicinesState extends State<Medicines> {
  bool showAll = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 40, 10, 10),
      child: Wrap(
        children: [
          Header(
            controller: widget.controller,
            buttonFunction: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditMedicine(
                    controller: widget.controller,
                  ),
                ),
              );
            },
          ),
          ProfileSummary(
            controller: widget.controller,
          ),
          MedicinesList(
            controller: widget.controller,
            // showAll: showAll,
          ),
          // ElevatedButton(
          //   onPressed: () {
          //     setState(() {
          //       showAll = true;
          //     });
          //   },
          //   child: Text("Ver Todos Remédios"),
          // ),
        ],
      ),
    );
  }
}
