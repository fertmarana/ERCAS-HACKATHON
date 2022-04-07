import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:subiupressao_app/app.dart';
import 'package:subiupressao_app/app_celular/Consultas/AppointmentsList.dart';
import 'package:subiupressao_app/database/Database_test.dart';
import 'package:subiupressao_app/globals.dart' as globals;
import 'dart:async';
import 'dart:core';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:subiupressao_app/bluetooth/connection/ProfileSummary.dart';
import 'package:subiupressao_app/app_celular/Components/Controller.dart';
import 'package:subiupressao_app/app_celular/Components/Header.dart';
import 'package:flutter_icons/flutter_icons.dart';
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
 // Controller controller;

 // connectionPage({@required this.controller});

  @override
  _connectionPage createState() => _connectionPage();
}

class _ChartData {
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
  int count = 0;
  double start_aplication = 0;
  List<Heart> testHeart = [];
  Heart testingHeart;
  ZoomPanBehavior _zoomPanBehavior;
  bool isreadingFrequency = false;
  bool nodataisbeingdetected = true;
  bool clicked_Ler_frequencia = false;
  int size_of_dataBase = 0;
  bool istryingtoconnect = false;

  void _updateDatabase(int _greatestValue, int count, DateTime dt) async {
    var fido = Heart(
      id: count,
      //dateTime: "a",//DateTime.now().minute.toString(),
      dateTime: dt,
      heartRate: _greatestValue,
    );
    await DBProvider.db.insertHeart(fido);
    size_of_dataBase = await DBProvider.db.getDatabaseSize();
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
        enablePinching: true);
    /*Timer.periodic(Duration(minutes: 1), (Timer t) => setState((){
      greatestValue = valuesofHeart;
      valuesofHeart = -1;

    }));*/

    heartRate = -1;
    super.initState();
    initBluetoothScanning();
    //  _updateDatabase(greatestValue);
  }

  void _updateDataSource(Timer timer) async {
    if(isConnected == false) return;
    if (valuesofHeart != -1) {
      greatestValue = valuesofHeart;
      valuesofHeart = -1;
      count++;
      chartData.add(_ChartData(count, greatestValue));



      _updateDatabase(greatestValue, count, DateTime.now());
      //print(await DBProvider.db.toString());
      // chartData.add(_ChartData(DateTime.now().minute.toInt(), greatestValue ));
    }

    if (chartData.length == 20) {
      // Removes the last index data of data source.
      chartData.removeAt(0);
      int len = chartData.length.toInt() - 1;
      // Here calling updateDataSource method with addedDataIndexes to add data in last index and removedDataIndexes to remove data from the last.
      _chartSeriesController?.updateDataSource(
          addedDataIndexes: <int>[(len)], removedDataIndexes: <int>[0]);
    }
  }

  void initBluetoothScanning() {
    flutterBlue.isScanning.listen((isScanning) {
      _isScanning = isScanning;
      setState(() {});
    });
  }

  scan() async {
    if (!_isScanning) {
      scanResultList.clear();
      await flutterBlue.startScan(timeout: Duration(seconds: 4));
      flutterBlue.scanResults.listen((results) {
        for (ScanResult r in results) {
          print(
              '${r.device.name} found! id: ${r.device.id.id} len: ${r.device.name.length} ');
          if (r.device.name.length > 0) {
            scanResultList.add(r);
          }
        }
        scanResultList = scanResultList.toSet().toList();
      });
    } else {
      flutterBlue.stopScan();
    }
  }

  void findCaracteristics(BluetoothService service) async {
    var characteristics = service.characteristics;
    for (BluetoothCharacteristic c in characteristics) {
      print("c:   ${c.uuid}");
      if (c.uuid.toString() == Guid("0002a3700001000800000805f9b34fb")) {
        var val = c.read();
        print("Printandoo valor ${val}");
      }
      List<int> value = await c.read();
      print("Characteristic: ${value}");
    }
  }

  void findServices(BluetoothDevice dev) async {
    clicked_Ler_frequencia = true;
    isreadingFrequency = true;
    List<BluetoothService> services = await dev.discoverServices();
    for (BluetoothService service in services) {
      // do something with service
      if (service.uuid.toString().toLowerCase()  == "0000180d-0000-1000-8000-00805f9b34fb") {
        for (BluetoothCharacteristic element in service.characteristics) {
          print("Characteristic uuid: ${element.uuid}");
          if (element.uuid.toString().toLowerCase() == CHARACTERISTIC_UUID) {
            _readthisCharacteristic(element);

            characteristicBluetooth = element;

            print(element.value);
          }
        }
      }
    }
  }

  void connectDevice(BluetoothDevice dev) async {

    Future<bool> returnValue;

    setState(() {
      device = dev;
      deviceConnected_name = device.name;

    });

    await device.connect() ;

    isConnected = true;

    //findServices(dev);


    print("Connection successful!");


  }

  disconnect(BluetoothDevice dev) async {

    isreadingFrequency = false;
    nodataisbeingdetected = true;
    await dev.disconnect();
    setState(() {
      deviceConnected_name = "";
      device = null;
      isConnected = false;
      DBProvider.db.deleteAll();
      clicked_Ler_frequencia = false;
      size_of_dataBase = 0;
      istryingtoconnect = false;
      //scanResultList.clear();
    });
  }

  _readInfoFromDevice(List values) async {
    if (values.length > 0) {

      globals.heartRate_global = await values[1];
      print("value: ${values}");
      print("valor da global ${globals.heartRate_global.toString()}");
      setState(() {
        nodataisbeingdetected = false;
        heartRate = values[1];
        if (heartRate > valuesofHeart) {
          valuesofHeart = heartRate;
        }
        //globals.heartRate_global = values[1];
        // widget.callback(heartRate);
      });
    } else {
      print("No info on device");
    }
  }

  void _readthisCharacteristic(BluetoothCharacteristic c) async {
    List<int> values = [];
    if (c.properties.read) {
      print("Reading properties from ${c.uuid}");
    } else {
      print("${c.uuid} can't be read");
    }

    if (c != null) {
      print("tentando ler de ${c.uuid}");
      await c.setNotifyValue(true);
      c.value.listen((value) {
        print("esperando e tentando ler de ${c.uuid}");
        _readInfoFromDevice(value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    timer = Timer.periodic(const Duration(seconds: 30), _updateDataSource);
    //print("start_application_value : ${start_aplication}");
    //testHeart = DBProvider.db.getAllClients();
    return Scaffold(
        body: Container(
        padding: EdgeInsets.fromLTRB(10, 80, 10, 0),
        height: 800,
        child: Column(
        children: [

        ProfileSummary(
       // controller: widget.controller,
        connected: isConnected,
        ),
        SizedBox(height: 1),
        Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
          height: 400,
          child: ListView(
            //runSpacing: 6.0,
            //direction: Axis.horizontal,
            children: [
              Container(
                child: SizedBox(
                  height: 200.0,
                  child: isConnected == false?
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: scanResultList.length,
                    itemBuilder: _itemBuilder,
                  ):
                  Column(children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(0,40,0,40),
                      alignment: Alignment(0.0, 0.6),
                      child: TextButton(
                        style: ButtonStyle(
                          foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),

                        ),
                        onPressed: () {
                          setState(() {
                            clicked_Ler_frequencia = true;
                          });

                          findServices(device);
                        },
                        child:
                        clicked_Ler_frequencia == false?
                        Text('Ler Frequência',style: TextStyle(fontSize: 14,color: Colors.blue),)
                        : size_of_dataBase == 0?
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(color: Colors.blue,),
                            SizedBox(width: 4,),
                            Text("Procurando Frequência...", style: TextStyle(fontSize: 14,color: Colors.blue),),

                          ],
                        ):
                        Text('Frequência Encontrada!',style: TextStyle(fontSize: 14,color: Colors.blue),)

                        ,

                      ),
                    ),

                    Container(
                        alignment: Alignment(0.0, 0.6),
                        child:TextButton(
                          style: ButtonStyle(
                            foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                          ),
                          onPressed: () {
                            disconnect(device);
                          },
                          child: Text('Desconectar'),
                        )
                    ),
                  ]),
                ),
              ),

              SizedBox(height: 10.0),
              Container(
                  child:
                  isConnected == false?
                  Align(
                alignment: Alignment.center,
                child:
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: ClipOval(
                    child: Material(
                      color: Colors.blue, // button color
                      child: MaterialButton(
                          minWidth: 100.0,
                          height: 100,
                          padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          shape: CircleBorder(),
                          onPressed: () {
                          scan();
                        }, // button pressed
                        child: _isScanning == false?
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.bluetooth,color: Colors.white,), // icon
                            Text("Escanear",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)), // text
                          ],
                        ):
                            CircularProgressIndicator(color: Colors.white,strokeWidth: 6,)
                      ),
                    ),
                  ),
                ),
              ):
                  Container(
                    child: isreadingFrequency?
                      Container (
                      child: nodataisbeingdetected?
                          Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Certifique-se que a pulseira está em seu pulso \n', textAlign: TextAlign.center,style: TextStyle(fontSize: 15.0, color: Colors.red)),
                                Text('Se estiver, espere um minuto que a leitura logo será feita\n', textAlign: TextAlign.center,style: TextStyle(fontSize: 15.0, color: Colors.red)),
                              ],
                          ):

                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Sua Frequência está sendo escaneada \n', textAlign: TextAlign.center,style: TextStyle(fontSize: 15.0, color: Color(0xff16613D))),
                              Text("Para conferir mais detalhes clique em", textAlign: TextAlign.center,style: TextStyle(fontSize: 15.0, color: Color(0xff16613D)) ),
                              Container(
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("Pressão", textAlign: TextAlign.center,style: TextStyle(fontSize: 15.0, color: Color(0xff16613D)) ),
                                    Icon(MaterialCommunityIcons.heart_pulse,color: Color(0xff16613D)),
                                    Text(' abaixo', textAlign: TextAlign.center,style: TextStyle(fontSize: 15.0, color: Color(0xff16613D)) ),
                                  ],
                                )
                            )
                            ],
                          )
                      ):
                      SizedBox(),
                  ),

              ),

            ],
            ),
          ),
        ]
        )
      )
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return InkWell(
        child: Card(
      child: Center(
        child:
        Column(children: <Widget>[
          Text(
            "${scanResultList[index].device.name}",
            style: TextStyle(
              fontSize: 28.0,
              color: Colors.orange,
            ),
          ),
        Container(
            alignment: Alignment(0.0, 0.6),
            child:
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            ),
            onPressed: () {
              setState(() {
                istryingtoconnect = true;
              });
              connectDevice(scanResultList[index].device);
            },
            child: istryingtoconnect == false?
            Text('Conectar ao Aparelho')
            :
            CircularProgressIndicator(color: Colors.blue,strokeWidth: 6,)
            ,
          )

        ),

        ]
        )
      ),
    ));
  }
}
