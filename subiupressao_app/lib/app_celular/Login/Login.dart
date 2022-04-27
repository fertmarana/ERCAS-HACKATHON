import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

import 'package:subiupressao_app/app.dart';
import 'package:subiupressao_app/app_celular/Components/Controller.dart';
import 'package:subiupressao_app/app_celular/Components/UserDataDropdown.dart';
import 'package:subiupressao_app/app_celular/Components/UserDataInput.dart';
import 'package:subiupressao_app/app_celular/Components/UserDateInput.dart';
import 'package:subiupressao_app/files/FileController.dart';
import 'package:subiupressao_app/files/models/appointment.dart';
import 'package:subiupressao_app/files/models/gender.dart';
import 'package:subiupressao_app/files/models/medicine.dart';
import 'package:subiupressao_app/files/models/user.dart';

class LoginPage extends StatelessWidget {
  final _nameController = TextEditingController();
  final _birthController = TextEditingController();
  final _genderController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  Controller controller = Controller();
  User _user;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    _user = context.select((FileController fileController) {
      fileController.deleteUser();
      fileController.readUser();
      return fileController.user;
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
                    UserDataDropdown(
                      controller: _genderController,
                      fieldName: "Gênero",
                      values:
                          Gender.values.map((gender) => gender.name).toList(),
                    ),
                    UserDateInput(
                      controller: _birthController,
                      dateTime: DateTime.now(),
                      fieldName: "Data de nascimento",
                    ),
                    Row(
                      children: [
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
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    SizedBox(height: 0.01 * size.height),
                    ElevatedButton(
                      child: Text(
                        "Confirmar",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      onPressed: () {
                        FileController fileController = new FileController();
                        _user = User(
                          name: _nameController.text,
                          birth: DateFormat("dd/MM/yyyy")
                              .parse(_birthController.text),
                          gender: _genderController.text,
                          weight: int.parse(_weightController.text),
                          height: int.parse(_heightController.text),
                          medicines: [
                            Medicine(
                              name: "Exemplo",
                              quantity: 0,
                              start: today,
                              end: today,
                            ),
                          ],
                          appointments: [
                            Appointment(
                              doctor: "Exemplo",
                              speciality: "Exemplo",
                              date: today,
                            ),
                          ],
                        );
                        
                        fileController.writeUser(_user);
                        this.controller.updateUser(newUser: _user);

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  App(controller: this.controller)),
                          (route) => false,
                        );
                      },
                    ),
                    SizedBox(height: 0.01 * size.height),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      this.controller.updateUser(newUser: _user);
      return App(controller: this.controller);
    }
  }
}
