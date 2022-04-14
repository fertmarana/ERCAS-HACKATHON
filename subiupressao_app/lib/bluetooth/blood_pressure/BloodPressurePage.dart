import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:collection/collection.dart';
import 'package:subiupressao_app/globals.dart' as globals;
import '../connection/connectionPage.dart';
import 'package:subiupressao_app/dataClass.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as Path;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:core';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:subiupressao_app/database/Database.dart';
import 'package:subiupressao_app/database/MeasuresDataModel.dart';
import 'package:subiupressao_app/bluetooth/heart/ProfileSummary.dart';
import 'package:subiupressao_app/bluetooth/blood_pressure/CountDownTimer.dart';
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
  static const maxSeconds= 60;
  double Q = 4.5;
  double Gen = 1;
  List<int> heartData = [];
  ZoomPanBehavior _zoomPanBehavior;
  ChartSeriesController _chartSeriesController;
  int curheartRate = -1;
  final isSelected = <bool>[true, false];
  bool isTimerRunning = false;
  Timer _timer;
  int seconds = maxSeconds;
  int Beats= 0;
  DateTime begin_measuring;
  DateTime end_measuring;
  int Wei = 60;
  int Hei = 160;
  int Agg = 23;

  @override
  void initState() {
    DBProvider.db.deleteAll();
    super.initState();
  }



  void getBloodPressure(){

    if(Gen == 1){
      Q = 5;
    }


    double ROB = 18.5;
    double ET = (364.5 - 1.23 * Beats);
    double BSA = 0.007184 * (pow(Wei, 0.425)) * (pow(Hei, 0.725));
    double SV = (-6.6 + (0.25 * (ET - 35)) - (0.62 * Beats) + (40.4 * BSA) - (0.51 * Agg));
    double PP = SV / ((0.013 * Wei - 0.007 * Agg - 0.004 * Beats) + 1.307);
    double MPP = Q * ROB;

    int SP = (MPP + 3 / 2 * PP).toInt();
    int DP = (MPP - PP / 3).toInt();
    print("Sias: $SP / Dias: $DP");
    setState(() {
      isTimerRunning = false;
    });
  }

  void _fetchDat() async{
    double aux =
    await DBProvider.db.getAVGHeartRateBetweenDateTimesDateTime(begin_measuring, end_measuring);
    if(aux != null) print("AUX IS $aux");
    else print("AUX IS NULL");
    setState(() {
      Beats = aux.toInt();

    });
    //curheartRate = heartData.last;
    return;
  }

  void collectingBeats(){
    Future.delayed( Duration(minutes: 2), (){
      _fetchDat();
      isTimerRunning = false;
      getBloodPressure();
    });

    //print("last value: $heartData.last.heartRate");


    //Beats = heartData.map((m) => m).average.toInt();
   // print("Beats average: $Beats");
    //getBloodPressure();
  }

  void startTimer() {

    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (seconds == 0) {
          setState(() {
            timer.cancel();
            seconds = maxSeconds;
            isTimerRunning = false;
          });
        } else {
          setState(() {
            seconds--;
            if(!isTimerRunning)  isTimerRunning = true;
          });
        }
      },
    );
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
          setState(() {
            begin_measuring = new DateTime.now();
            end_measuring = begin_measuring.add(new Duration(minutes: 1));
            isTimerRunning = true;
          });
          print("begin: $begin_measuring");
          print("end: $end_measuring");


            collectingBeats();

          /*
          Future.delayed(Duration(minutes: 2), () {
            _fetchDat();
          });*/
        },
        child: Text("Medir Pressão"),
      ),
    isTimerRunning ?
    CircularProgressIndicator(color: Colors.blue,strokeWidth: 6,)
    :Text("beats: $Beats")

    ]
    )
    );
  }

}