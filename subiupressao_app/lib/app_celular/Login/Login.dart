import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import 'package:subiupressao_app/app.dart';
import 'package:subiupressao_app/app_celular/Components/UserDataInput.dart';
import 'package:subiupressao_app/files/FileController.dart';
import 'package:subiupressao_app/files/models/appointment.dart';
import 'package:subiupressao_app/files/models/medicine.dart';
import 'package:subiupressao_app/files/models/user.dart';

class LoginPage extends StatelessWidget {
  final _ageController = TextEditingController();
  final _nameController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  User _user;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    _user = context.select((FileController controller) {
      // controller.deleteUser();
      controller.readUser();
      return controller.user;
    });

    if (_user == null) {
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);

      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        body: Column(
          children: [
            SizedBox(height: 0.1 * size.height),
            Image.asset('imagens/SubiuPressao.png'),
            SizedBox(height: 0.05 * size.height),
            SizedBox(
              height: 0.70 * size.height,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 0.05 * size.height),
                    Text("Cadastre-se", style: TextStyle(fontSize: 24)),
                    UserDataInput(
                      controller: _nameController,
                      fieldName: "Nome",
                      hintString: "Insira seu nome aqui",
                    ),
                    UserDataInput(
                      controller: _ageController,
                      keyboard: TextInputType.number,
                      filter: [FilteringTextInputFormatter.digitsOnly],
                      fieldName: "Idade",
                      hintString: "Insira sua idade aqui",
                    ),
                    Row(children: [
                      UserDataInput(
                        controller: _weightController,
                        keyboard: TextInputType.number,
                        filter: [FilteringTextInputFormatter.digitsOnly],
                        fieldName: "Peso (kg)",
                        hintString: "Peso",
                        maxWidth: 0.4,
                      ),
                      SizedBox(
                        width: 0.05 * size.width,
                      ),
                      UserDataInput(
                        controller: _heightController,
                        keyboard: TextInputType.number,
                        filter: [FilteringTextInputFormatter.digitsOnly],
                        fieldName: "Altura (cm)",
                        hintString: "Altura",
                        maxWidth: 0.4,
                      ),
                    ], mainAxisAlignment: MainAxisAlignment.center),
                    SizedBox(height: 0.05 * size.height),
                    ElevatedButton(
                      child: Text(
                        "Confirmar",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      onPressed: () {
                        FileController controller = new FileController();
                        controller.writeUser(
                          _nameController.text,
                          int.parse(_ageController.text),
                          int.parse(_weightController.text),
                          int.parse(_heightController.text),
                          [
                            Medicine(
                              name: "Exemplo",
                              quantity: 0,
                              start: today,
                              end: today,
                            ),
                          ],
                          [
                            Appointment(
                              doctor: "Exemplo",
                              speciality: "Exemplo",
                              date: today,
                            ),
                          ],
                        );

                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => App()),
                            (route) => false);
                      },
                    ),
                    SizedBox(height: 0.05 * size.height),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return App();
    }
  }
}
