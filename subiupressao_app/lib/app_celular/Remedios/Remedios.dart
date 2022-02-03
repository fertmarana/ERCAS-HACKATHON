import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

import 'package:subiupressao_app/app_celular/Remedios/Header.dart';
import 'package:subiupressao_app/app_celular/Remedios/MedicinesList.dart';
import 'package:subiupressao_app/app_celular/Remedios/ProfileSummary.dart';
import 'package:subiupressao_app/app_celular/Remedios/RemediosController.dart';
import 'package:subiupressao_app/files/FileController.dart';

// TODO: usar página de remédios para marcar os remédios já tomados no dia
// Ajuda no dia-a-dia de quem tem que tomar muitos remédios e pode esquecer
// (meu pai)

class Remedios extends StatelessWidget {
  MedicineController controller = new MedicineController();

  @override
  Widget build(BuildContext context) {
    if (controller.user == null) {
      controller.updateUser(
        newUser: context.select(
          (FileController fileController) {
            fileController.readUser();
            return fileController.user;
          },
        ),
      );
    }

    if (controller.dateTime == null) {
      controller.updateDateTime(newDateTime: DateTime.now());
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(10, 40, 10, 10),
      child: Wrap(children: [
        Header(controller: controller),
        ProfileSummary(controller: controller),
        MedicinesList(controller: controller),
      ]),
    );
  }
}
