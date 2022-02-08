import 'package:flutter/material.dart';

import 'package:subiupressao_app/app_celular/Components/Header.dart';
import 'package:subiupressao_app/app_celular/Remedios/EditMedicine.dart';
import 'package:subiupressao_app/app_celular/Remedios/MedicinesList.dart';
import 'package:subiupressao_app/app_celular/Remedios/ProfileSummary.dart';
import 'package:subiupressao_app/app_celular/Components/Controller.dart';

// TODO: usar página de remédios para marcar os remédios já tomados no dia
// Ajuda no dia-a-dia de quem tem que tomar muitos remédios e pode esquecer

class Remedios extends StatelessWidget {
  Controller controller;

  Remedios({@required this.controller});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        size.width * 0.03,
        size.height * 0.05,
        size.width * 0.03,
        size.height * 0.01,
      ),
      child: Wrap(
        children: [
          Header(
            controller: controller,
            buttonFunction: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditMedicine(
                    dateTime: controller.dateTime,
                    controller: controller,
                  ),
                ),
              );
            },
          ),
          ProfileSummary(controller: controller),
          MedicinesList(controller: controller),
        ],
      ),
    );
  }
}
