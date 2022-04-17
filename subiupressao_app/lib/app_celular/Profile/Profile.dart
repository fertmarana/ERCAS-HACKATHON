import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'package:subiupressao_app/app_celular/Components/Controller.dart';
import 'package:subiupressao_app/app_celular/Components/Header.dart';
import 'package:subiupressao_app/app_celular/Profile/InfoField.dart';
import 'package:subiupressao_app/app_celular/Profile/MedicalReport.dart';
import 'package:subiupressao_app/app_celular/Profile/ProfileSummary.dart';
import 'package:subiupressao_app/files/models/user.dart';

class Profile extends StatelessWidget {
  Controller controller;

  Profile({this.controller});

  List<Widget> showUserData(double height) {
    return [
      InfoField(
        controller: controller,
        field: "Nome",
        data: controller.user.name,
      ),
      SizedBox(height: height * 0.01),
      InfoField(
        controller: controller,
        field: "Idade",
        data: controller.user.age.toString(),
      ),
      SizedBox(height: height * 0.01),
      InfoField(
        controller: controller,
        field: "Altura",
        data: controller.user.height.toString(),
      ),
      SizedBox(height: height * 0.01),
      InfoField(
        controller: controller,
        field: "Peso",
        data: controller.user.weight.toString(),
      ),
      SizedBox(height: height * 0.01),
      InfoField(
        controller: controller,
        field: "Data de nascimento",
        data: DateFormat('dd/MM/yyyy').format(controller.user.birth),
      ),
      SizedBox(height: height * 0.01),
      InfoField(
        controller: controller,
        field: "CPF",
        data: controller.user.cpf,
      ),
      SizedBox(height: height * 0.01),
      InfoField(
        controller: controller,
        field: "Plano de saúde",
        data: controller.user.healthInsurance,
      ),
      SizedBox(height: height * 0.01),
      InfoField(
        controller: controller,
        field: "Situação cardíaca",
        data: controller.user.cardiacSituation,
      ),
      // SizedBox(height: height * 0.01),
      // InfoField(
      //   controller: controller,
      //   field: "Pressão média",
      //   data: controller.user.ordinaryPressure.toString(),
      // ),
      SizedBox(height: height * 0.02),
    ];
  }

  @override
  Widget build(BuildContext context) {
    MedicalReport report = MedicalReport(controller: controller);
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.fromLTRB(10, 40, 10, 10),
      child: Column(
        children: [
          Header(
            buttonFunction: report.generateMedicalReport,
            controller: controller,
          ),
          ProfileSummary(controller: controller),
          SizedBox(height: size.height * 0.02),
          Container(
            child: Center(
              child: ListView(
                children: showUserData(size.height),
              ),
            ),
            width: size.width * 0.9,
            height: size.height * 0.45,
          ),
          SizedBox(height: size.height * 0.02),
          ElevatedButton(
            onPressed: report.generateMedicalReport,
            child: Text("Gerar Relatório Médico"),
          )
        ],
      ),
    );
  }
}
