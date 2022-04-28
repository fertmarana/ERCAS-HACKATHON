import 'package:flutter/material.dart';
import 'package:subiupressao_app/bluetooth/blood_pressure/BloodPressurePage.dart';

import 'package:subiupressao_app/dataClass.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:core';
import 'package:intl/intl.dart';
import 'package:subiupressao_app/database/Database.dart';
import 'package:subiupressao_app/database/MeasuresDataModel.dart';
import 'package:subiupressao_app/bluetooth/heart/ProfileSummary.dart';

import 'package:subiupressao_app/app_celular/Components/Controller.dart';

class HeartRatePage extends StatefulWidget {
  final myData dat;
  Controller controller;
 HeartRatePage({Key key, @required this.dat,this.controller}) : super(key: key);


  //heartRatePage(this.Heartrate, this.callback);

  //heartRatePage({Key key, @required this.promise}) : super(key: key);

  @override
  _HeartRatePage createState() => _HeartRatePage();
}

class _HeartRatePage extends State<HeartRatePage> {
  int hr ;
  List<Heart> heartData = [];
  ChartSeriesController _chartSeriesController;
  int curheartRate  = -1;
  final isSelected = <bool>[true, false];

  var page_controller = PageController(
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
      
    if (heartData.length > 0) curheartRate = heartData.last.heartRate;
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

             curheartRate != -1?
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

              ):
              Text("Nenhum dado ainda")
            ,
            SizedBox(height: 1),
            curheartRate == -1?
              SizedBox(height: 1,):
              isSelected[0] == true?
              FrequencyPage()
              : _Pressao()
              // _Pressao()
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
                    controller: page_controller,
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

  Widget _Pressao() {
    return Container(
    padding: EdgeInsets.fromLTRB(10, 90, 10, 0),
    height: 270,

    child: Column(
      children: [
        MaterialButton(
        minWidth: 180.0,
        height: 180,
        padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),


        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BloodPressurePage(controller: widget.controller),
            ),
          );
        }, // button pressed
        child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 100,
              width: 180,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('imagens/blood-pressure.png'),
                  //fit: BoxFit.cover,
                ),
              ),
            ),
            Text("\n"),
            // icon
            Text("Medir Pressão",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18.0,
                    color: Color(0xffc80b50),
                    fontWeight: FontWeight.bold)), // text
          ],
        )
        )
      ]
    )
    );
  }

}
