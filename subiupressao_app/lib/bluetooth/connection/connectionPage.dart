import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter/material.dart';
import 'package:subiupressao_app/app_celular/Components/Controller.dart';
import 'package:subiupressao_app/app_celular/Components/Header.dart';
import 'package:subiupressao_app/bluetooth/connection/ProfileSummary.dart';
import 'package:subiupressao_app/globals.dart' as globals;
import 'dart:async';
import 'dart:core';
import 'package:subiupressao_app/database/MeasuresDataModel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:subiupressao_app/database/Database.dart';
import 'package:intl/intl.dart';

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
  String deviceConnectedName = "";
  static const CHARACTERISTIC_UUID = "00002a37-0000-1000-8000-00805f9b34fb";
  bool isConnected;
  int heartRate = -1;
  bool isReading = false;
  int greatestValue = 0;
  int valuesofHeart = -1;
  List<_ChartData> chartData = <_ChartData>[];
  int count = 0;
  double startAplication = 0;
  List<Heart> testHeart = [];
  Heart testingHeart;

  @override
  void initState() {
    startAplication = DateTime.now().minute.toDouble();
    isConnected = false;
    heartRate = -1;
    super.initState();
    initBluetoothScanning();
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
      if (c.uuid.toString() == CHARACTERISTIC_UUID) {
        var val = c.read();
        print("Printandoo valor $val");
      }
      List<int> value = await c.read();
      print("Characteristic: $value");
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
      deviceConnectedName = device.name;
    });

    await device
        .connect();
        isConnected = true;

        findServices(dev);
        print("Connection successful!");

  }

  disconnect() async {
    await device.disconnect();
    setState(() {
      deviceConnectedName = " ";
      device = null;
      isConnected = false;
    });
  }

  _readInfoFromDevice(List values) async {
    if (values.length > 0) {
      globals.heartRateGlobal = await values[1];
      print("value: ${values[1]}");
      print("valor da global ${globals.heartRateGlobal.toString()}");
      setState(() {
        heartRate = values[1];
        if (heartRate > valuesofHeart) {
          valuesofHeart = heartRate;
        }
      });
    } else {
      print("No info on device");
    }
  }

  void _readthisCharacteristic(BluetoothCharacteristic c) async {
    if (c.properties.read) {
      print("Reading properties from ${c.uuid}");
    } else {
      print("${c.uuid} can't be read");
    }
    print("to aqui");
    if (c != null) {
      await c.setNotifyValue(true);
      c.value.listen((value) {
        _readInfoFromDevice(value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print("start_application_value : $startAplication");

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          size.width * 0.03,
          size.height * 0.05,
          size.width * 0.03,
          size.height * 0.03,
        ),
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
            SizedBox(
              height: size.height * 0.04,
            ),
            Image.asset(
              'imagens/dispositivo.png',
              height: size.width * 0.5,
              width: size.width * 0.5,
              alignment: Alignment.topCenter,
              fit: BoxFit.fitWidth,
            ),
            Container(
              child: SizedBox(
                height: size.height * 0.2,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: scanResultList.length,
                  itemBuilder: _itemBuilder,
                ),
              ),
            ),
            /*
            Container(
              child: SizedBox(
                height: size.height * 0.2,
                child: Text("Frequencia: " + heartRate.toString()),
              ),
            ),*/
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
            child: Text('Conectar'),
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
                      },
                      child: Text('Ler Frequência'),
                    )
                  : //IMPORTANTE TER ISSO PORQUE É UMA CONDICAO NAO APAGAR
                  SizedBox()),
        ]),
      ),
    ));
  }
}
