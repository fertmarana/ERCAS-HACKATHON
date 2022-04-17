
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as Path;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:core';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:subiupressao_app/database/Database.dart';
import 'package:subiupressao_app/database/MeasuresDataModel.dart';
import 'package:percent_indicator/percent_indicator.dart';
class BloodPressurePage extends StatefulWidget {

  //BloodPressurePage({Key key, @required this.dat}) : super(key: key);
  //final myData dat;

  @override
  _BloodPressurePage createState() => _BloodPressurePage();
}

class _BloodPressurePage extends State<BloodPressurePage> {
  int hr;
  static const maxSeconds= 60*2;
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
  double Beats= 0;
  DateTime begin_measuring;
  DateTime end_measuring;
  double Wei = 60;
  double Hei = 160;
  int Agg = 24;
  int SP = 0;
  int DP = 0;
  int percent = 0;

  @override
  void initState() {

    DBProvider.db.deleteAll();

    super.initState();
  }

  void start_loading(){
    _timer = Timer.periodic(Duration(seconds: (maxSeconds/10).toInt() ),(_){
      setState(() {
        percent+=10;
        if(percent >= 100){
          isTimerRunning = false;

          _timer.cancel();
          collectingBeats();
          // percent=0;
        }
      });
    });
  }

  void getBloodPressure(){

    if(Gen == 1){
      Q = 5;
    }
    Hei = (Hei / 30.48); //convertendo cm em fts
    Wei = (Wei * 2.205); //convertendo kilos to pounds
    print("Beats: $Beats");
    double ROB = 18.5;
    double ET = (364.5 - 1.23 * Beats);
    double BSA = 0.007184 * (pow(Wei, 0.425)) * (pow(Hei, 0.725));
    double SV = (-6.6 + (0.25 * (ET - 35)) - (0.62 * Beats) + (40.4 * BSA) - (0.51 * Agg));
    double PP = SV / ((0.013 * Wei - 0.007 * Agg - 0.004 * Beats) + 1.307);
    double MPP = Q * ROB;

    double SPD = (MPP + 3 / 2 * PP);
    double DPD = (MPP - PP / 3);

    SP = (MPP + 3 / 2 * PP).toInt();
    //DP = (MPP - PP / 3).toInt();
    DP = (SP - PP - 12.0667).toInt();
    print("Hei $Hei and Wei $Wei");
    print("ET: $ET");
    print("BSA $BSA");
    print("SV: $SV");
    print("PP: $PP");
    print("MPP: $MPP");
    print("Sias: $SP / Dias: $DP");
    print("SIAS: $SPD AND DIAS: $DPD");
    setState(() {
      isTimerRunning = false;
      percent = 0;
    });
  }

  void _fetchDat() async{
    double aux =
    await DBProvider.db.getAVGHeartRateBetweenDateTimesDateTime(begin_measuring, end_measuring);
    if(aux != null) print("AUX IS $aux");
    else print("AUX IS NULL");
    setState(() {
      Beats = aux;
      getBloodPressure();
    });

    //curheartRate = heartData.last;
    return;
  }

  void collectingBeats(){

   // Future.delayed( Duration(seconds: maxSeconds), (){
      _fetchDat();
      isTimerRunning = false;
      //getBloodPressure();
    //});

  }


  @override
  Widget build(BuildContext context) {

    return Container(
    padding: EdgeInsets.fromLTRB(10, 90, 10, 0),
    height: 800,
    child: Column(
    children: [
      SizedBox(height: 10,),
      isTimerRunning ?
        CircularPercentIndicator(
          radius: 150.0,
          lineWidth: 13.0,
          animation: false,
          percent: percent/100,
          center: Text(
            percent.toString() + "%",
            style:
            TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
          circularStrokeCap: CircularStrokeCap.round,
          progressColor: Colors.blue,
        ): Pressao_Mostrar(),
      SizedBox(height: 5,),
      OutlinedButton(
        onPressed: () {
          setState(() {
            begin_measuring = new DateTime.now();
            end_measuring = begin_measuring.add(new Duration(seconds: maxSeconds));
            isTimerRunning = true;
          });
          print("begin: $begin_measuring");
          print("end: $end_measuring");

          start_loading();
          //collectingBeats();

          /*
          Future.delayed(Duration(minutes: 2), () {
            _fetchDat();
          });*/
        },
        child: Text("Medir Pressão"),
      ),


    ]
    )
    );
  }

Widget Pressao_Mostrar(){
  return Container(
      margin: new EdgeInsets.fromLTRB(10, 0, 10, 0),
      width: 190.0,
      height: 100.0,
      child: Card(

        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0)),
        color: Color(0xfffa8989).withOpacity(0.6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(width: 3,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                new Text(
                  'SIS: $SP | DIA: $DP',
                ),
              ],
            ),
          ],
        ),
      ));
}



}