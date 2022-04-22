import 'package:subiupressao_app/app_celular/Components/Controller.dart';
import 'package:subiupressao_app/app_celular/Profile/pdf.dart';
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
