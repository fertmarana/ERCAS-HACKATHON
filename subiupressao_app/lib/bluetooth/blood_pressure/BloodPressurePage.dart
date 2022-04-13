import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter/material.dart';

import 'package:subiupressao_app/globals.dart' as globals;
import '../connection/connectionPage.dart';
import 'package:subiupressao_app/dataClass.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as Path;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:core';
import 'package:intl/intl.dart';
import 'package:subiupressao_app/database/Database.dart';
import 'package:subiupressao_app/database/MeasuresDataModel.dart';
import 'package:subiupressao_app/bluetooth/heart/ProfileSummary.dart';

import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:subiupressao_app/app_celular/Components/Controller.dart';

class BloodPressurePage extends StatefulWidget {

  //BloodPressurePage({Key key, @required this.dat}) : super(key: key);
  //final myData dat;

  @override
  _BloodPressurePage createState() => _BloodPressurePage();
}

class _BloodPressurePage extends State<BloodPressurePage> {
  int hr;
  double Q = 4.5;
  double Gen = 1;
  List<Heart> heartData = [];
  ZoomPanBehavior _zoomPanBehavior;
  ChartSeriesController _chartSeriesController;
  int curheartRate = -1;
  final isSelected = <bool>[true, false];

  @override
  void initState() {
    DBProvider.db.deleteAll();
    super.initState();
  }

  Future<List<Heart>> _fetchDat() async{
    List<Heart> aux = await DBProvider.db.getAllClients();
    setState(() {
      heartData = aux;

    });
    curheartRate = heartData.last.heartRate;
    return heartData;
  }

  void getBloodPressure(int Beats){

    if(Gen == 1){
      Q = 5;
    }

  /*
    double ROB = 18.5;
    double ET = (364.5 - 1.23 * Beats);
    double BSA = 0.007184 * (Math.pow(Wei, 0.425)) * (Math.pow(Hei, 0.725));
    double SV = (-6.6 + (0.25 * (ET - 35)) - (0.62 * Beats) + (40.4 * BSA) - (0.51 * Agg));
    double PP = SV / ((0.013 * Wei - 0.007 * Agg - 0.004 * Beats) + 1.307);
    double MPP = Q * ROB;

    int SP = (MPP + 3 / 2 * PP);
    int DP = (MPP - PP / 3);
  */
  }



  @override
  Widget build(BuildContext context) {

    return Container(
    padding: EdgeInsets.fromLTRB(10, 90, 10, 0),
    height: 800,
    child: Column(
    children: [
      OutlinedButton(
        onPressed: () {
          // Respond to button press
          Future.delayed(Duration(minutes: 2), () {
            _fetchDat();
          });
        },
        child: Text("Medir Pressão"),
      )
      ]
    )
    );
  }

}