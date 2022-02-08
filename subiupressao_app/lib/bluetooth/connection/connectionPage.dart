import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:subiupressao_app/app.dart';
import 'package:subiupressao_app/app_celular/Components/Controller.dart';
import 'package:subiupressao_app/app_celular/Components/Header.dart';
import 'package:subiupressao_app/bluetooth/connection/ProfileSummary.dart';
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

class ConnectionPage extends StatefulWidget {
  Controller controller;

  ConnectionPage({@required this.controller});

  @override
  _ConnectionPageState createState() => _ConnectionPageState();
}

class _ChartData {
  int minute;
  int epoch;
  _ChartData(this.minute, this.epoch);
}

class _ConnectionPageState extends State<ConnectionPage> {
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
  int count = 0;
  double start_aplication = 0;
  List<Heart> testHeart = [];
  Heart testingHeart;
  ZoomPanBehavior _zoomPanBehavior;

  void _updateDatabase(int _greatestValue, int count, DateTime dt) async {
    var fido = Heart(
      id: count,
      //dateTime: "a",//DateTime.now().minute.toString(),
      dateTime: dt,
      heartRate: _greatestValue,
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
    List<BluetoothService> services = await dev.discoverServices();
    for (BluetoothService service in services) {
      // do something with service
      if (service.uuid.toString() == "0000180d-0000-1000-8000-00805f9b34fb") {
        for (BluetoothCharacteristic element in service.characteristics) {
          print("Characteristic uuid: ${element.uuid}");
          if (element.uuid.toString() == CHARACTERISTIC_UUID) {
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

    await device
        .connect(timeout: Duration(seconds: 10))
        .timeout(Duration(seconds: 10), onTimeout: () {
      returnValue = Future.value(false);
    }).then((data) {
      if (returnValue == null) {
        isConnected = true;

        findServices(dev);
        List<List> values = [];

        print("Connection successful!");
      }
    });
  }

  disconnect() async {
    await device.disconnect();
    setState(() {
      deviceConnected_name = " ";
      device = null;
      isConnected = false;
    });
  }

  _readInfoFromDevice(List values) async {
    if (values.length > 0) {
      globals.heartRate_global = await values[1];
      print("value: ${values[1]}");
      print("valor da global ${globals.heartRate_global.toString()}");
      setState(() {
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
    Timer timer =
        Timer.periodic(const Duration(seconds: 30), _updateDataSource);
    Size size = MediaQuery.of(context).size;

    print("start_application_value : ${start_aplication}");

    //testHeart = DBProvider.db.getAllClients();

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(10, 40, 10, 10),
        child: Column(
          children: [
            Header(
                controller: widget.controller,
                buttonFunction: () {
                  // TODO: verificar se bluetooth está ativado
                  scan();
                }),
            ProfileSummary(
              controller: widget.controller,
              connected: isConnected,
            ),
            SizedBox(height: size.height * 0.05,),
            Image.asset(
              'imagens/dispositivo.png',
              height: size.width * 0.5,
              width: size.width * 0.5,
              alignment: Alignment.topCenter,
              fit: BoxFit.fitWidth,
            ),
            Container(
              child: SizedBox(
                height: size.height * 0.3,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: scanResultList.length,
                  itemBuilder: _itemBuilder,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return InkWell(
        child: Card(
      child: Center(
        child: Column(children: <Widget>[
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
              child: isConnected
                  ? TextButton(
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                      ),
                      onPressed: () {
                        findServices(device);
                        //_readCharacteristics();
                      },
                      child: Text('Read Heart Rate'),
                    )
                  : //IMPORTANTE TER ISSO PORQUE É UMA CONDICAO NAO APAGAR
                  SizedBox()),
        ]),
      ),
    ));
  }
}
