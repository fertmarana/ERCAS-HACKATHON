import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter/material.dart';
import 'package:subiupressao_app/app_celular/Components/Controller.dart';
import 'package:subiupressao_app/app_celular/Components/Header.dart';
import 'package:subiupressao_app/bluetooth/HeartRate/ProfileSummary.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as Path;
import 'dart:io';
import 'package:subiupressao_app/bluetooth/connection/connectionPage.dart';
import 'dart:async';
import 'package:subiupressao_app/dataClass.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:core';
import 'package:intl/intl.dart';
import 'package:subiupressao_app/database/Database.dart';
import 'package:subiupressao_app/database/MeasuresDataModel.dart';

class HeartRatePage extends StatefulWidget {
  Controller controller;
  final MyData dat;

  HeartRatePage({Key key, @required this.dat, @required this.controller})
      : super(key: key);

  @override
  _HeartRatePage createState() => _HeartRatePage();
}

class _HeartRatePage extends State<HeartRatePage> {
  int hr;
  List<Heart> heartData = [];
  int curheartRate = 0;
  ChartSeriesController _chartSeriesController;

  var controller2 = PageController(
    viewportFraction: 1,
    initialPage: 0,
  );

  @override
  void initState() {
    DBProvider.db.deleteAll();
    super.initState();
  }

  void find_heartRate() async {
   for(int i=0; i<heartData.length;i++) {
     print("heart : ${heartData[i].heartRate}");
   }
  }


  Future<List<Heart>> _fetchDat() async {

      List<Heart> aux = await DBProvider.db.getAllClients();
      setState(() {
        heartData = aux;
      });
      /*
      try{
        curheartRate = aux.last.heartRate;

      } catch(){
        curheartRate = -1;
      }*/
      curheartRate = -1;
      print("PRINTAAAAAAAAAAAAAAAAAA");
      find_heartRate();
      return heartData;
  }

  void deleteDatabase() async {
    await DBProvider.db.deleteAll();
    heartData.clear();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Future.delayed(Duration(seconds: 10), () {
      _fetchDat();
    });
    find_heartRate();
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.fromLTRB(
        size.width * 0.03,
        size.height * 0.05,
        size.width * 0.03,
        size.height * 0.015,
      ),
      child: Column(children: [
        Header(controller: widget.controller, buttonFunction: () {
          find_heartRate();
          _fetchDat();}),
        SizedBox(height: size.height * 0.015),
        Container(
          alignment: Alignment(0.0, 0.6),
          child: curheartRate == -1
              ? SizedBox()
              : //IMPORTANTE TER ISSO PORQUE É UMA CONDICAO NAO APAGAR
              ProfileSummary(
                  controller: widget.controller,
                  heartRate: curheartRate,
                ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.symmetric(vertical: 10.0),
          height: size.height * 0.55,
          width: size.width,
          child: PageView(
              controller: controller2,
              scrollDirection: Axis.horizontal,
              children: [
                Container(
                  child: SfCartesianChart(
                    title: ChartTitle(text: "Frequência"),
                    enableAxisAnimation: true,
                    primaryXAxis: DateTimeAxis(
                      dateFormat: DateFormat.Hms(),
                      intervalType: DateTimeIntervalType.minutes,
                      axisLine: AxisLine(width: 0),
                      majorTickLines: MajorTickLines(size: 0),
                    ),
                    series: <LineSeries<Heart, DateTime>>[
                      LineSeries<Heart, DateTime>(
                        onRendererCreated: (ChartSeriesController controllerChart){
                          _chartSeriesController = controllerChart;
                        },
                        // Binding the chartData to the dataSDateTimeource of the line series.
                        dataSource: heartData,
                        xValueMapper: (Heart data, _) => data.dateTime,
                        yValueMapper: (Heart data, _) => data.heartRate,
                      )
                    ],
                  ),
                ),
                Container(
                  child: SizedBox(
                      child: ListView.builder(
                    itemCount: heartData.length,
                    itemBuilder: (BuildContext context, int position) {
                      final item = heartData[position];
                      //get your item data here ...
                      return Card(
                        child: ListTile(
                          title: Text(
                            "Frequência:  " +
                                heartData[position].toStringHeart() +
                                '\n' +
                                "Data: " +
                                heartData[position].toStringDateTime(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                  )),
                ),
              ]),
        ),
      ]),
    ));
  }
}
