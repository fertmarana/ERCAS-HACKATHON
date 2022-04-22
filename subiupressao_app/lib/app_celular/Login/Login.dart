import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

import 'package:subiupressao_app/app.dart';
import 'package:subiupressao_app/app_celular/Components/UserDataDropdown.dart';
import 'package:subiupressao_app/app_celular/Components/UserDataInput.dart';
import 'package:subiupressao_app/app_celular/Components/UserDateInput.dart';
import 'package:subiupressao_app/files/FileController.dart';
import 'package:subiupressao_app/files/models/appointment.dart';
import 'package:subiupressao_app/files/models/bloodPressure.dart';
import 'package:subiupressao_app/files/models/gender.dart';
import 'package:subiupressao_app/files/models/medicine.dart';
import 'package:subiupressao_app/files/models/user.dart';

class LoginPage extends StatelessWidget {
  final _nameController = TextEditingController();
  final _birthController = TextEditingController();
  final _genderController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  User _user;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    _user = context.select((FileController controller) {
      controller.deleteUser();
      controller.readUser();
      return controller.user;
    });

    // FileController().writeUser(_user);

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
                        FileController controller = new FileController();
                        // _user = User(
                        //   name: _nameController.text,
                        //   birth: DateFormat("dd/MM/yyyy")
                        //       .parse(_birthController.text),
                        //   gender: _genderController.text,
                        //   weight: int.parse(_weightController.text),
                        //   height: int.parse(_heightController.text),
                        //   medicines: [
                        //     Medicine(
                        //       name: "Exemplo",
                        //       quantity: 0,
                        //       start: today,
                        //       end: today,
                        //     ),
                        //   ],
                        //   appointments: [
                        //     Appointment(
                        //       doctor: "Exemplo",
                        //       speciality: "Exemplo",
                        //       date: today,
                        //     ),
                        //   ],
                        // );
                        _user = User(
                            name: "Lucas Cardoso",
                            birth: DateTime.now(),
                            weight: 100,
                            height: 190,
                            medicines: [],
                            appointments: [],
                            bloodPressure:
                                BloodPressure(diastolic: 7, systolic: 11),
                            cardiacSituation: "Saudável",
                            cpf: "111.111.111-11",
                            dayBloodPressure: [],
                            monthBloodPressure: [
                              BloodPressure(
                                  systolic: 11,
                                  diastolic: 8,
                                  // time: DateTime(2022, 3, 1)),
                              ),
                              BloodPressure(
                                  systolic: 11,
                                  diastolic: 8,
                                  // time: DateTime(2022, 3, 2)),
                              ),
                              BloodPressure(
                                  systolic: 11,
                                  diastolic: 8,
                                  // time: DateTime(2022, 3, 3)),
                              ),
                              BloodPressure(
                                  systolic: 11,
                                  diastolic: 8,
                                  // time: DateTime(2022, 3, 4)),
                              ),
                              BloodPressure(
                                  systolic: 11,
                                  diastolic: 8,
                                  // time: DateTime(2022, 3, 5)),
                              ),
                              BloodPressure(
                                  systolic: 11,
                                  diastolic: 8,
                                  // time: DateTime(2022, 3, 6)),
                              ),
                              BloodPressure(
                                  systolic: 11,
                                  diastolic: 8,
                                  // time: DateTime(2022, 3, 7)),
                              ),
                              BloodPressure(
                                  systolic: 11,
                                  diastolic: 8,
                                  // time: DateTime(2022, 3, 8)),
                              ),
                              BloodPressure(
                                  systolic: 11,
                                  diastolic: 8,
                                  // time: DateTime(2022, 3, 9)),
                              ),
                              BloodPressure(
                                systolic: 11,
                                diastolic: 8,
                                // time: DateTime(2022, 3, 10),
                              ),
                              BloodPressure(
                                systolic: 11,
                                diastolic: 8,
                                // time: DateTime(2022, 3, 11),
                              ),
                              BloodPressure(
                                systolic: 11,
                                diastolic: 8,
                                // time: DateTime(2022, 3, 12),
                              ),
                              BloodPressure(
                                systolic: 11,
                                diastolic: 8,
                                // time: DateTime(2022, 3, 13),
                              ),
                              BloodPressure(
                                systolic: 11,
                                diastolic: 8,
                                // time: DateTime(2022, 3, 14),
                              ),
                              BloodPressure(
                                systolic: 11,
                                diastolic: 8,
                                // time: DateTime(2022, 3, 15),
                              ),
                              BloodPressure(
                                systolic: 11,
                                diastolic: 8,
                                // time: DateTime(2022, 3, 16),
                              ),
                              BloodPressure(
                                systolic: 11,
                                diastolic: 8,
                                // time: DateTime(2022, 3, 17),
                              ),
                              BloodPressure(
                                systolic: 11,
                                diastolic: 8,
                                // time: DateTime(2022, 3, 18),
                              ),
                              BloodPressure(
                                systolic: 11,
                                diastolic: 8,
                                // time: DateTime(2022, 3, 19),
                              ),
                              BloodPressure(
                                systolic: 11,
                                diastolic: 8,
                                // time: DateTime(2022, 3, 20),
                              ),
                              BloodPressure(
                                systolic: 11,
                                diastolic: 8,
                                // time: DateTime(2022, 3, 21),
                              ),
                              BloodPressure(
                                systolic: 11,
                                diastolic: 8,
                                // time: DateTime(2022, 3, 22),
                              ),
                              BloodPressure(
                                systolic: 11,
                                diastolic: 8,
                                // time: DateTime(2022, 3, 23),
                              ),
                              BloodPressure(
                                systolic: 11,
                                diastolic: 8,
                                // time: DateTime(2022, 3, 24),
                              ),
                              BloodPressure(
                                systolic: 11,
                                diastolic: 8,
                                // time: DateTime(2022, 3, 25),
                              ),
                              BloodPressure(
                                systolic: 11,
                                diastolic: 8,
                                // time: DateTime(2022, 3, 26),
                              ),
                              BloodPressure(
                                systolic: 11,
                                diastolic: 8,
                                // time: DateTime(2022, 3, 27),
                              ),
                              BloodPressure(
                                systolic: 11,
                                diastolic: 8,
                                // time: DateTime(2022, 3, 28),
                              ),
                              BloodPressure(
                                systolic: 11,
                                diastolic: 8,
                                // time: DateTime(2022, 3, 29),
                              ),
                              BloodPressure(
                                systolic: 11,
                                diastolic: 8,
                                // time: DateTime(2022, 3, 30),
                              ),
                              BloodPressure(
                                systolic: 11,
                                diastolic: 8,
                                // time: DateTime(2022, 3, 31),
                              ),
                            ],
                            dayHeartRate: [75, 118, 96, 54, 77],
                            gender: "Masculino",
                            healthInsurance: "111.111.111-11",
                            monthHeartRate: [
                              76, // 1
                              77, // 2
                              78, // 3
                              79, // 4
                              78, // 5
                              77, // 6
                              76, // 7
                              75, // 8
                              74, // 9
                              73, // 10
                              72, // 11
                              71, // 12
                              72, // 13
                              73, // 14
                              74, // 15
                              75, // 16
                              76, // 17
                              77, // 18
                              78, // 19
                              79, // 20
                              78, // 21
                              77, // 22
                              76, // 23
                              75, // 24
                              74, // 25
                              73, // 26
                              72, // 27
                              71, // 28
                              72, // 29
                              73, // 30
                              74, // 31
                            ]);


                        controller.writeUser(_user);

                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => App()),
                            (route) => false);
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
      return App();
    }
  }
}
