import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:subiupressao_app/app_celular/Components/Header.dart';
import 'package:subiupressao_app/app_celular/Remedios/EditMedicine.dart';
import 'package:subiupressao_app/app_celular/Remedios/MedicinesList.dart';
import 'package:subiupressao_app/app_celular/Remedios/ProfileSummary.dart';
import 'package:subiupressao_app/app_celular/Components/Controller.dart';
import 'package:subiupressao_app/files/FileController.dart';

// TODO: usar página de remédios para marcar os remédios já tomados no dia
// Ajuda no dia-a-dia de quem tem que tomar muitos remédios e pode esquecer

class Remedios extends StatelessWidget {
  Controller controller;

  Remedios({@required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 40, 10, 10),
      child: Wrap(
        children: [
          Header(
            controller: controller,
            buttonFunction: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditMedicine(
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
