import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' as io;

import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:subiupressao_app/app.dart';
import 'package:subiupressao_app/app_celular/Components/ProfilePicture.dart';
import 'package:subiupressao_app/app_celular/Components/UserDataInput.dart';
import 'package:subiupressao_app/files/FileController.dart';
import 'package:subiupressao_app/files/models/appointment.dart';
import 'package:subiupressao_app/files/models/medicine.dart';
import 'package:subiupressao_app/files/models/user.dart';

class LoginPage extends StatelessWidget {
  final _ageController = TextEditingController();
  final _nameController = TextEditingController();
  User _user;

  @override
  Widget build(BuildContext context) {
    _user = context.select((FileController controller) {
      // controller.deleteUser();
      controller.readUser();
      return controller.user;
    });

    if (_user == null) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        body: Column(
          children: [
            SizedBox(height: 80),
            Image.asset('imagens/SubiuPressao.png'),
            SizedBox(height: 30),
            SizedBox(
              height: 520,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 30),
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
                    SizedBox(height: 15),
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
                          [
                            Medicine(
                              name: "Exemplo",
                              quantity: 0,
                              start: DateTime.now(),
                              end: DateTime.now(),
                            ),
                          ],
                          [
                            Appointment(
                              doctor: "Exemplo",
                              speciality: "Exemplo",
                              date: DateTime.now(),
                            ),
                          ],
                        );

                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => App()),
                            (route) => false);
                      },
                    ),
                    SizedBox(height: 15),
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
