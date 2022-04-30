import 'dart:math';

import 'package:subiupressao_app/app_celular/Components/Controller.dart';
import 'package:subiupressao_app/app_celular/Profile/pdf.dart';
import 'package:subiupressao_app/files/models/bloodPressure.dart';
import 'package:subiupressao_app/files/models/user.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class MedicalReport {
  Controller controller;
  User _user;

  MedicalReport({Controller controller}) {
    _user = controller.user;

    controller.addListener(() {
      _user = controller.user;
    });
  }

  Future<void> campusMobileReport() async {
    _user.monthBloodPressure = [];
    var rng = Random();

    _user.bloodPressure = BloodPressure(
      systolic: 9 + rng.nextInt(6),
      diastolic: 7 + rng.nextInt(4),
    );

    for (int i = 0; i < 31; i++) {
      BloodPressure pressure = BloodPressure();

      pressure.diastolic = _user.bloodPressure.diastolic - 2 + rng.nextInt(4);
      pressure.systolic = _user.bloodPressure.systolic - 3 + rng.nextInt(6);

      _user.monthBloodPressure.add(pressure);
    }

    if (_user.bloodPressure.systolic < 14) {
      _user.cardiacSituation = "Normal";
    } else {
      _user.cardiacSituation = "Alta";
    }

    await generateMedicalReport();
  }

  Future<void> generateMedicalReport() async {
    PdfDocument document = presetDocument();

    document = await addCover(
      coverImageName: 'SubiuPressao_contorno.png',
      darkMode: true,
      document: document,
    );

    document = await addUserInfoPage(
      user: _user,
      darkMode: true,
      document: document,
    );

    document = await addBloodPressurePage(
      user: _user,
      darkMode: true,
      document: document,
    );

    await saveAndLaunchFile(fileName: 'medicalReport.pdf', document: document);
  }
}
