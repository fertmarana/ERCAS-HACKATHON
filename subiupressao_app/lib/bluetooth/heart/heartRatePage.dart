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

// import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:subiupressao_app/app_celular/Components/Controller.dart';

class HeartRatePage extends StatefulWidget {

 HeartRatePage({Key key, @required this.dat}) : super(key: key);
 final myData dat;

  //heartRatePage(this.Heartrate, this.callback);

  //heartRatePage({Key key, @required this.promise}) : super(key: key);

  @override
  _HeartRatePage createState() => _HeartRatePage();
}

class _HeartRatePage extends State<HeartRatePage> {
  int hr ;
  List<Heart> heartData = [];
  ZoomPanBehavior _zoomPanBehavior;
  ChartSeriesController _chartSeriesController;
  int curheartRate  = -1;
  final isSelected = <bool>[true, false];

  var controller = PageController(
    viewportFraction: 1 ,
    initialPage: 0,
  );



  @override
  void initState() {
    DBProvider.db.deleteAll();
    super.initState();
  }



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
          padding: EdgeInsets.fromLTRB(10, 90, 10, 0),
          height: 800,
          child: Column(
            children: [
            ProfileSummary(
             heartRate : curheartRate,
            ),
              ToggleButtons(
                color: Colors.black.withOpacity(0.60),
                selectedColor: Color(0xFF6200EE),
                selectedBorderColor: Color(0xFF6200EE),
                fillColor: Color(0xFF6200EE).withOpacity(0.08),
                splashColor: Color(0xFF6200EE).withOpacity(0.12),
                hoverColor: Color(0xFF6200EE).withOpacity(0.04),
                borderRadius: BorderRadius.circular(4.0),
                constraints: BoxConstraints(minHeight: 36.0),
                isSelected: isSelected,
                onPressed: (index) {
                  // Respond to button selection
                  setState(() {
                    isSelected[index] = true;
                    isSelected[1-index] = false;
                  });
                },
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('Frequência'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('Pressão'),
                  ),

                ],
              ),
            SizedBox(height: 1),
            isSelected[0] == true?
            FrequencyPage()
            : FrequencyPage() // _Pressao()
            ,
            ]
          )
          )
      );
  }

  Widget FrequencyPage() {
    return Expanded(
        child: ListView(
            children: [

              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                height: 400.0,
                width: 400,
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
                                    leading: position == 0  ||
                                        ( heartData[position].get_hearetRate() == heartData[position-1].get_hearetRate() ) ?
                                    Icon(Icons.circle_outlined, color: Colors.blue, )
                                  : heartData[position].get_hearetRate() > heartData[position-1].get_hearetRate()?
                                    Icon(Icons.arrow_upward_sharp , color: Colors.green, )
                                        :Icon(Icons.arrow_downward_sharp , color: Colors.red, ),
                                    title: Text(
                                      // "Data: " + heartData[position].toString()

                                      "Frequência:  " + heartData[position].toStringHeart() + '\n' +
                                          "Data: "
                                          + heartData[position].toStringdateTime_day() + "/"
                                          + heartData[position].toStringdateTime_month()  + "/"
                                          + heartData[position].toStringdateTime_year()  + "\n"
                                          + heartData[position].toStringdateTime_hour() + ":"
                                          + heartData[position].toStringdateTime_minute() + ":"
                                          + heartData[position].toStringdateTime_second() + ""
                                      ,
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
    );

  }

  // Widget _Pressao() {
  //   return SfRadialGauge(
  //       title: GaugeTitle(
  //           text: 'Pressão',
  //           textStyle:
  //           const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
  //       axes: <RadialAxis>[
  //         RadialAxis(minimum: 0, maximum: 150, ranges: <GaugeRange>[
  //           GaugeRange(
  //               startValue: 0,
  //               endValue: 50,
  //               color: Colors.green,
  //               startWidth: 10,
  //               endWidth: 10),
  //           GaugeRange(
  //               startValue: 50,
  //               endValue: 100,
  //               color: Colors.orange,
  //               startWidth: 10,
  //               endWidth: 10),
  //           GaugeRange(
  //               startValue: 100,
  //               endValue: 150,
  //               color: Colors.red,
  //               startWidth: 10,
  //               endWidth: 10)
  //         ], pointers: <GaugePointer>[
  //           NeedlePointer(value: 90)
  //         ], annotations: <GaugeAnnotation>[
  //           GaugeAnnotation(
  //               widget: Container(
  //                   child: const Text('90.0',
  //                       style: TextStyle(
  //                           fontSize: 25, fontWeight: FontWeight.bold))),
  //               angle: 90,
  //               positionFactor: 0.5)
  //         ])
  //       ]);
  // }


}
