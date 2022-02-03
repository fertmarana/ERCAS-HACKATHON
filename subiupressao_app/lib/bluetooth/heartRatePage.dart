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
    return Padding(
        padding: EdgeInsets.fromLTRB(10, 70, 10, 10),
    child: Wrap(
    runSpacing: 6.0,
    direction: Axis.horizontal,
    children: [
      /*
      Container(
        alignment: Alignment(0.0, 0.6),
        child: FutureBuilder(
          future: this.promise,
          builder: (BuildContext context, AsyncSnapshot snapshot){
            return Text('Heart Rate: ' + snapshot.data.toString(),
                style: TextStyle(
                fontSize: 28.0,
                color: Color(0xff16613D)
                ),
                );
          },
        )
      ),
      */
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
                  print("Encontreee");
                  find_hearRate();
                  _fetchDat();
                  //heartData = await DBProvider.db.getAllClients();
                },
                child:
                Text("Update: " ,
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
                  print("Encontreee");
                  deleteDatabase();
                  //heartData = await DBProvider.db.getAllClients();
                },
                child:
                Text("Delete all: " ,
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
      child: SizedBox(
      height: 200.0,
        child:   ListView.builder(
            itemCount: heartData.length,
            itemBuilder: (BuildContext context, int position) {
            final item = heartData[position];
            //get your item data here ...
            return Card(
              child: ListTile(
                title: Text(
                "Data " + heartData[position].toString()),
              ),
            );
            },
          )
      ),
      ),
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
      ),

      /*
      Container(
        child: SizedBox(
          height: 200.0,
          child:   FutureBuilder<List>(
            future: _fetchDat(),
            initialData: [],
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int position) {
                  final item = snapshot.data[position];
                  //get your item data here ...
                  return Card(
                    child: ListTile(
                      title: Text(
                          "Data " + snapshot.data[position].toString()),
                    ),
                  );
                },
              )
                  : Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),*/



    ]
    )
    );
  }


}