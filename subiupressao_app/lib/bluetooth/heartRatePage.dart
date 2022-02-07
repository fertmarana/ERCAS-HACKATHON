import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter/material.dart';
import 'package:subiupressao_app/globals.dart' as globals;
import 'connectionPage.dart';
import 'dart:async';
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

class heartRatePage extends StatefulWidget {
 heartRatePage({Key key, @required this.dat}) : super(key: key);
 final myData dat;

  //heartRatePage(this.Heartrate, this.callback);

  //heartRatePage({Key key, @required this.promise}) : super(key: key);

  @override
  _heartRatePage createState() => _heartRatePage();
}

class _heartRatePage extends State<heartRatePage> {
  int hr ;
  List<Heart> heartData = [];
  ZoomPanBehavior _zoomPanBehavior;
  ChartSeriesController _chartSeriesController;
  int curheartRate  = -1;

  var controller = PageController(
    viewportFraction: 1 ,
    initialPage: 0,
  );



  @override
  void initState() {
    DBProvider.db.deleteAll();
    super.initState();
  }

  /*
  List<Heart> getHeartRate() {
    List<Heart> hr = [];
    Future<List<Heart>> future_hr = DBProvider.db.getAllClients();
    future_hr.then((value) {
      value.forEach((element) {
        hr.add(Heart.fromMap(element));
      });
    });

    return hr;
  }*/



  void find_hearRate() async{
    //final int h = await globals.heartRate_global;
    for(int i =0; i<heartData.length; i++){

      print("heart: ${heartData[i].heartRate}");
    }

   // hr = h;
  }

  Future<List<Heart>> _fetchDat() async{
    List<Heart> aux = await DBProvider.db.getAllClients();
    setState(() {
      heartData = aux;

    });
    curheartRate = heartData.last.heartRate;
    return heartData;
  }


  void deleteDatabase() async {
    await DBProvider.db.deleteAll();
    heartData.clear();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 10), (){
      _fetchDat();
    });
    return
      Scaffold(
          body: Container(
          padding: EdgeInsets.fromLTRB(10, 70, 10, 10),
          height: 800,
          child:
            ListView(
              children: [
                      /*
                      Container(
                          child: Align(
                            alignment: Alignment.center,
                            child: Material(
                              borderRadius: BorderRadius.circular(30.0),
                              color: Color(0xFF009E74),
                              child: MaterialButton(
                                minWidth: 200.0,
                                padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                onPressed: () {
                                  //scanForDevices();

                                  find_hearRate();
                                  _fetchDat();
                                  //heartData = await DBProvider.db.getAllClients();
                                },
                                child:
                                Text("Atualizar" ,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 18.0,color: Colors.white, fontWeight: FontWeight.bold)
                                )
                                ,
                              ),
                            ),

                          )
                      ),
                      Container(
                          child: Align(
                            alignment: Alignment.center,
                            child: Material(
                              borderRadius: BorderRadius.circular(30.0),
                              color: Colors.red,
                              child: MaterialButton(
                                minWidth: 200.0,
                                padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                onPressed: () {
                                  //scanForDevices();

                                  deleteDatabase();
                                  //heartData = await DBProvider.db.getAllClients();
                                },
                                child:
                                Text("Deletar"))
                            )
                          )
                      ),*/
                      Container(
                        alignment: Alignment(0.0, 0.6),
                        child: curheartRate == -1?
                        SizedBox()
                            : //IMPORTANTE TER ISSO PORQUE É UMA CONDICAO NAO APAGAR
                        Text('Última Frequência Registrada: ' + curheartRate.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 28.0,
                              color: Color(0xff16613D)
                          ),
                        ),

                      ),
                      /*
                      Container(
                      child: SfCartesianChart(
                        // zoomPanBehavior: _zoomPanBehavior,

                        title: ChartTitle(text: "Heart Measure per Minute"),
                        //enableAxisAnimation: true,
                        primaryXAxis: DateTimeAxis(
                          dateFormat: DateFormat.Hms(),
                          intervalType: DateTimeIntervalType.minutes,
                          // Edge labels will be shifted
                          //edgeLabelPlacement: EdgeLabelPlacement.shift,
                          //autoScrollingDelta: 5,
                          //interval: 6,
                          axisLine: AxisLine(width: 0),
                          // visibleMinimum: start_aplication,
                          majorTickLines: MajorTickLines(size: 0),
                        ),
                        //legend: Legend(isVisible: true),
                        series: <LineSeries<Heart, DateTime>>[
                          LineSeries<Heart, DateTime>(
                            onRendererCreated: (ChartSeriesController controller) {
                              // Assigning the controller to the _chartSeriesController.
                              _chartSeriesController = controller;

                            },
                            // Binding the chartData to the dataSDateTimeource of the line series.
                            //name: "Heart Measure",
                            dataSource: heartData,
                            xValueMapper: (Heart data, _) => data.dateTime,//data.dateTime.minute.toString(),
                            yValueMapper: (Heart data, _) => data.heartRate,
                          )
                        ],
                        // primaryXAxis: NumericAxis(edgeLabelPlacement: EdgeLabelPlacement.shift, numberFormat: NumberFormat.simpleCurrency(decimalDigits: 0)),
                      ),
                ),*/
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  height: 400.0,
                  width: 500,
                  child:
                      PageView(
                          controller: controller,
                          scrollDirection: Axis.horizontal,
                          children: [
                            Container(
                              child: SfCartesianChart(
                                 //zoomPanBehavior: _zoomPanBehavior,

                                title: ChartTitle(text: "Frequência"),
                                enableAxisAnimation: true,
                                primaryXAxis: DateTimeAxis(
                                  dateFormat: DateFormat.Hms(),
                                  intervalType: DateTimeIntervalType.minutes,

                                  // Edge labels will be shifted
                                  //edgeLabelPlacement: EdgeLabelPlacement.shift,
                                  //autoScrollingDelta: 5,
                                  //interval: 6,
                                  axisLine: AxisLine(width: 0),
                                  // visibleMinimum: start_aplication,
                                  majorTickLines: MajorTickLines(size: 0),
                                ),
                                //legend: Legend(isVisible: true),
                                series: <LineSeries<Heart, DateTime>>[
                                  LineSeries<Heart, DateTime>(
                                    onRendererCreated: (ChartSeriesController controller) {
                                      // Assigning the controller to the _chartSeriesController.
                                      _chartSeriesController = controller;

                                    },
                                    // Binding the chartData to the dataSDateTimeource of the line series.
                                    //name: "Heart Measure",
                                    dataSource: heartData,
                                    xValueMapper: (Heart data, _) => data.dateTime,//data.dateTime.minute.toString(),
                                    yValueMapper: (Heart data, _) => data.heartRate,
                                  )
                                ],
                                // primaryXAxis: NumericAxis(edgeLabelPlacement: EdgeLabelPlacement.shift, numberFormat: NumberFormat.simpleCurrency(decimalDigits: 0)),
                              ),
                            ),
                            Container(
                              child: SizedBox(
                                // height: 400.0,
                                  child:   ListView.builder(
                                    itemCount: heartData.length,
                                    itemBuilder: (BuildContext context, int position) {
                                      final item = heartData[position];
                                      //get your item data here ...
                                      return Card(
                                        child: ListTile(
                                          title: Text(
                                             // "Data: " + heartData[position].toString()
                                            "Frequência:  " + heartData[position].toStringHeart() + '\n' + "Data: " + heartData[position].toStringDateTime(),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      );
                                    },
                                  )
                              ),
                            ),
                          ]
                        ),
                ),

                ]
              )
          )
      );
  }


}