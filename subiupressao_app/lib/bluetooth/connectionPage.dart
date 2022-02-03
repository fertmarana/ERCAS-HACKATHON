import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:subiupressao_app/app.dart';
import 'package:subiupressao_app/database/Database_test.dart';
import 'package:subiupressao_app/globals.dart' as globals;
import 'dart:async';
import 'dart:core';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:path/path.dart';

import 'package:subiupressao_app/database/Database.dart';
import 'package:subiupressao_app/database/MeasuresDataModel.dart';

// UUIDS DOS SERVICOS QUE VAMOS USAR
/*
0002a37-0000-1000-8000-00805f9b34fb"), "Heart Rate Measurement");
00002a39-0000-1000-8000-00805f9b34fb"), "Heart Rate Control Point");
"00002a49-0000-1000-8000-00805f9b34fb"), "Blood Pressure Feature");
"00002a35-0000-1000-8000-00805f9b34fb"), "Blood Pressure Measurement");

*/
class connectionPage extends StatefulWidget {
 // int Heartrate;
  //Function(int) callback;
  //connectionPage(this.Heartrate, this.callback);

  //connectionPage({Key key, @required this.Heartrate,this.callback}) : super(key: key);

  @override
  _connectionPage createState() => _connectionPage();
}

class _ChartData{
  int minute;
  int epoch;
  _ChartData(this.minute, this.epoch);
}


class _connectionPage extends State<connectionPage> {
  BluetoothService _service;
  BluetoothDevice device;
  BluetoothState state;
  BluetoothCharacteristic characteristicBluetooth;
  BluetoothDeviceState deviceState;
  StreamSubscription<BluetoothState> scanSubscription;
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<ScanResult> scanResultList = [];
  Stream<List<int>> listStream;
  bool _isScanning = true;
  final Map<Guid, List<int>> readValues = new Map<Guid, List<int>>();
  String deviceConnected_name = "";
  static const CHARACTERISTIC_UUID = "00002a37-0000-1000-8000-00805f9b34fb";
  bool isConnected;
  int heartRate;
  bool isReading = false;
  int greatestValue = 0;
  int valuesofHeart = -1;
  List<_ChartData> chartData = <_ChartData>[];
  ChartSeriesController _chartSeriesController;
  Timer timer;
  int count =0;
  double start_aplication=0;
  List<Heart> testHeart = [];
  Heart testingHeart;
  ZoomPanBehavior _zoomPanBehavior;

  void _updateDatabase(int _greatestValue,int count, DateTime dt) async {
    var fido = Heart(
      id: count,
      //dateTime: "a",//DateTime.now().minute.toString(),
      dateTime: dt,
      heartRate: _greatestValue ,
    );
    await DBProvider.db.insertHeart(fido);

    setState(() {
      testHeart.add(fido);
    });

    print("DONEEEEEEEEEEEEEEEEEEEEEE");
  }

  @override
  void initState() {
    start_aplication = DateTime.now().minute.toDouble();
    // TODO: implement initState
    isConnected = false;
    _zoomPanBehavior = ZoomPanBehavior(
      // Enables pinch zooming
        enableDoubleTapZooming: true,
        enablePinching: true
    );
    /*Timer.periodic(Duration(minutes: 1), (Timer t) => setState((){
      greatestValue = valuesofHeart;
      valuesofHeart = -1;

    }));*/

    heartRate = -1;
    super.initState();
    initBluetoothScanning();
  //  _updateDatabase(greatestValue);


  }

  void _updateDataSource(Timer timer)  async{
    if(valuesofHeart != -1){
      greatestValue = valuesofHeart;
      valuesofHeart = -1;
      count++;
      chartData.add(_ChartData(count, greatestValue ));

      _updateDatabase(greatestValue,count, DateTime.now());
      //print(await DBProvider.db.toString());
      // chartData.add(_ChartData(DateTime.now().minute.toInt(), greatestValue ));
    }


    if (chartData.length == 20) {
      // Removes the last index data of data source.
      chartData.removeAt(0);
      int len = chartData.length.toInt() -1;
      // Here calling updateDataSource method with addedDataIndexes to add data in last index and removedDataIndexes to remove data from the last.
      _chartSeriesController?.updateDataSource(addedDataIndexes: <int>[(len)],
          removedDataIndexes: <int>[0]);
    }

  }



  void initBluetoothScanning(){
    flutterBlue.isScanning.listen((isScanning) {
      _isScanning = isScanning;
      setState(() {});
    });
  }

  scan() async{
    if(!_isScanning){
      scanResultList.clear();
      flutterBlue.startScan(timeout: Duration(seconds: 4));
      flutterBlue.scanResults.listen((results) {
        for (ScanResult r in results) {
          print('${r.device.name} found! id: ${r.device.id.id} len: ${r.device.name.length} ');
          if(r.device.name.length> 0){
            scanResultList.add(r);
          }
        }
        scanResultList = scanResultList.toSet().toList();
        setState(() { });
      });
    }else{
      flutterBlue.stopScan();
    }
  }




  void findCaracteristics(BluetoothService service) async{
    var characteristics = service.characteristics;
    for(BluetoothCharacteristic c in characteristics) {
      print("c:   ${c.uuid}");
      if(c.uuid.toString() == Guid("0002a3700001000800000805f9b34fb")){
        var val = c.read();
        print("Printandoo valor ${val}");
      }
      List<int> value = await c.read();
      print("Characteristic: ${value}");
    }
  }

  void findServices(BluetoothDevice dev) async {

    List<BluetoothService> services = await dev.discoverServices();
    for (BluetoothService service in services) {
      // do something with service
      print("foiiiii");
      if(service.uuid.toString() == "0000180d-0000-1000-8000-00805f9b34fb") {
        print("UUID SERVICE: ${service.uuid.toString()}");
        //findCaracteristics(service);
        for (BluetoothCharacteristic element in service.characteristics) {
          //service.characteristics.forEach((element) {
          print("Characteristic uuid: ${element.uuid}");
          //if(element.uuid.toString() == "0002a37-0000-1000-8000-00805f9b34fb"){
          if (element.uuid.toString() == CHARACTERISTIC_UUID) {
            print("é sim");
            _readthisCharacteristic(element);

            characteristicBluetooth = element;

            print(element.value);

          }
        }
      }
    }
  }

  void connectDevice(BluetoothDevice dev) async{
    setState(() {
      device = dev;
      deviceConnected_name = device.name;

    });
    await device.connect() ;
    isConnected = true;
    findServices(dev); List<List> values = [];
  }


  disconnect() async{

    await device.disconnect();
    setState(() {
      deviceConnected_name = " ";
      device = null;
      isConnected = false;
    });
  }

  _readInfoFromDevice(List values) async{
    if(values.length>0){
      globals.heartRate_global = await values[1];
      print("value: ${values[1]}");
      print("valor da global ${globals.heartRate_global.toString()}");
      setState(() {
        heartRate = values[1];
        if(heartRate > valuesofHeart){
          valuesofHeart = heartRate;
        }
        //globals.heartRate_global = values[1];
       // widget.callback(heartRate);
      });

    }else{
      print("ta vazio");
    }
  }

  void _readthisCharacteristic(BluetoothCharacteristic c) async {
    List<int> values = [];
    print("to aqui");
    if(c.properties.read){
      print("ele le");
    }
    if (c != null ) {
      print("tentando ler");
      await c.setNotifyValue(true);
      c.value.listen((value) {
        _readInfoFromDevice(value);
      });
      }
  }

  void _readCharacteristics() async {
    List<List> values = [];
    if (_service != null) {
      for (BluetoothCharacteristic c in _service.characteristics) {
        values.add(await c.read());
      }
    }
    heartRate = values[0][0];
  }

  @override
  Widget build(BuildContext context) {
    timer =  Timer.periodic(const Duration(seconds: 30), _updateDataSource);
    print("start_application_value : ${start_aplication}");
    //testHeart = DBProvider.db.getAllClients();
    return Scaffold(
        body: Container(
        padding: EdgeInsets.fromLTRB(10, 70, 10, 10),
        height: 800,
        child:
          ListView(
            //runSpacing: 6.0,
            //direction: Axis.horizontal,
            children: [
              SizedBox(height: 10.0),
              Container(
                alignment: Alignment(0.0, 0.6),
                child: isConnected ?
                Text('Connected to \n' + deviceConnected_name,
                  style: TextStyle(
                      fontSize: 28.0,
                      color: Color(0xff16613D)
                  ),
                )
                    : //IMPORTANTE TER ISSO PORQUE É UMA CONDICAO NAO APAGAR
                Text('No Device Connected',
                  style: TextStyle(
                      fontSize: 28.0,
                      color: Color(0xff16613D)
                  ),
                ),

              ),
              Container(
                child: SizedBox(
                  height: 200.0,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: scanResultList.length,
                    itemBuilder: _itemBuilder,
                  ),
                ),
              ),
              Container(
                alignment: Alignment(0.0, 0.6),
                child: heartRate == -1?
                SizedBox()
                    : //IMPORTANTE TER ISSO PORQUE É UMA CONDICAO NAO APAGAR
                Text('Heart Rate: ' + heartRate.toString(),
                  style: TextStyle(
                      fontSize: 28.0,
                      color: Color(0xff16613D)
                  ),
                ),

              ),
              Container(
                alignment: Alignment(0.0, 0.6),
                child: heartRate == -1?
                SizedBox()
                    : //IMPORTANTE TER ISSO PORQUE É UMA CONDICAO NAO APAGAR
                Text('Date Time: ' + DateTime.now().minute.toString(),
                  style: TextStyle(
                      fontSize: 28.0,
                      color: Color(0xff16613D)
                  ),
                ),

              ),
              Container(
                alignment: Alignment(0.0, 0.6),
                child: heartRate == -1?
                SizedBox()
                    : //IMPORTANTE TER ISSO PORQUE É UMA CONDICAO NAO APAGAR
                Text('Greatest Value this minute: \n' + greatestValue.toString(),
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Color(0xff16613D)
                  ),
                ),

              ),
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
                          scan();
                        },
                        child:
                        isConnected ?

                        Text("Scan Again",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20.0,color: Colors.white, fontWeight: FontWeight.bold)
                        ):
                        Text("Scan for Devices",
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
                child: SfCartesianChart(
                  zoomPanBehavior: _zoomPanBehavior,
                  title: ChartTitle(text: "Heart Measure per Minute"),
                  //enableAxisAnimation: true,
                  primaryXAxis: NumericAxis(
                    // Edge labels will be shifted
                      edgeLabelPlacement: EdgeLabelPlacement.shift,
                      interval: 10,
                      axisLine: AxisLine(width: 2),
                      majorTickLines: MajorTickLines(size: 0),

                  ),
                  //legend: Legend(isVisible: true),
                  series: <LineSeries<_ChartData, int>>[
                    LineSeries<_ChartData, int>(
                      onRendererCreated: (ChartSeriesController controller) {
                        // Assigning the controller to the _chartSeriesController.
                        _chartSeriesController = controller;

                      },
                      // Binding the chartData to the dataSource of the line series.
                      //name: "Heart Measure",
                      dataSource: chartData,
                      xValueMapper: (_ChartData data, _) => data.minute,
                      yValueMapper: (_ChartData data, _) => data.epoch,
                    )
                  ],
                 // primaryXAxis: NumericAxis(edgeLabelPlacement: EdgeLabelPlacement.shift, numberFormat: NumberFormat.simpleCurrency(decimalDigits: 0)),
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
                    axisLine: AxisLine(width: 3),
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
                      dataSource: testHeart,
                      xValueMapper: (Heart data, _) => data.dateTime,//data.dateTime.minute.toString(),
                      yValueMapper: (Heart data, _) => data.heartRate,
                    )
                  ],
                  // primaryXAxis: NumericAxis(edgeLabelPlacement: EdgeLabelPlacement.shift, numberFormat: NumberFormat.simpleCurrency(decimalDigits: 0)),
                ),
              ),
              Container(
                child: SfCartesianChart(

                  zoomPanBehavior: _zoomPanBehavior,
                  onTooltipRender: (args){
                    String yValue = args.dataPoints[args.pointIndex].y.toString();
                    args.text = DateTime.fromMillisecondsSinceEpoch(int.parse(yValue))
                        .minute
                        .toString();
                    /*
                        DateTime.fromMillisecondsSinceEpoch(int.parse(yValue))
                        .minute
                        .toString() +
                    ':' +
                    DateTime.fromMillisecondsSinceEpoch(int.parse(yValue))
                        .second
                        .toString() +
                    ':' +
                    DateTime.fromMillisecondsSinceEpoch(int.parse(yValue))
                        .millisecond
                        .toString();
                    */
                  },
                  title: ChartTitle(text: "Heart Measure per Minute"),
                  //enableAxisAnimation: true,
                  primaryXAxis: CategoryAxis(
                    
                    // Edge labels will be shifted
                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                    autoScrollingDelta: 5,
                    interval: 6,
                    axisLine: AxisLine(width: 0),
                    // visibleMinimum: start_aplication,
                    majorTickLines: MajorTickLines(size: 0),
                  ),
                  //legend: Legend(isVisible: true),
                  series: <LineSeries<Heart, String>>[
                    LineSeries<Heart,String>(
                      onRendererCreated: (ChartSeriesController controller) {
                        // Assigning the controller to the _chartSeriesController.
                        _chartSeriesController = controller;

                      },
                      // Binding the chartData to the dataSDateTimeource of the line series.
                      //name: "Heart Measure",
                      dataSource: testHeart,
                      xValueMapper: (Heart data, _) => DateTime.fromMillisecondsSinceEpoch(int.parse(DateTime.now().second.toString()))
                          .minute
                          .toString(),//data.dateTime.minute.toString(),
                      yValueMapper: (Heart data, _) => data.heartRate,
                    )
                  ],
                  // primaryXAxis: NumericAxis(edgeLabelPlacement: EdgeLabelPlacement.shift, numberFormat: NumberFormat.simpleCurrency(decimalDigits: 0)),
                ),
              ),
            ],
          ),
        )
    );
  }


  Widget _itemBuilder(BuildContext context, int index) {
    return InkWell(
      child: Card(
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                "${scanResultList[index].device.name}",
                style: TextStyle(
                  fontSize: 28.0,
                  color: Colors.orange,
                ),
              ),
              TextButton(
              style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                ),
                onPressed: () {
                connectDevice(scanResultList[index].device);
                },
                child: Text('Connect to Device'),
              ),
              Container(
                alignment: Alignment(0.0, 0.6),
                child: isConnected ?
                TextButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  onPressed: () {
                    findServices(device);
                    //_readCharacteristics();
                  },
                  child: Text('Read Heart Rate'),
                )
                    : //IMPORTANTE TER ISSO PORQUE É UMA CONDICAO NAO APAGAR
                SizedBox()

              ),
          ]
        ),
      ),
    )
    );
  }



}