import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter/material.dart';
import 'package:subiupressao_app/app.dart';
import 'package:subiupressao_app/globals.dart' as globals;
import 'dart:async';

// UUIDS DOS SERVICOS QUE VAMOS USAR
/*
0002a37-0000-1000-8000-00805f9b34fb"), "Heart Rate Measurement");
00002a39-0000-1000-8000-00805f9b34fb"), "Heart Rate Control Point");
"00002a49-0000-1000-8000-00805f9b34fb"), "Blood Pressure Feature");
"00002a35-0000-1000-8000-00805f9b34fb"), "Blood Pressure Measurement");
*/

class connectionPage extends StatefulWidget {
  @override
  _connectionPage createState() => _connectionPage();
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
  Text _btnText;
  String _deviceConnectionInfo;

  @override
  void initState() {
    isConnected = false;
    _deviceConnectionInfo = "Connect to Device";
    _btnText = Text("Scan for Devices",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.bold));
    super.initState();
    initBluetoothScanning();
    heartRate = -1;
  }

  void initBluetoothScanning() {
    flutterBlue.isScanning.listen((isScanning) {
      _isScanning = isScanning;
      setState(() {});
    });
  }

  scan() async {
    setState(() {
      _btnText = Text("Scanning...",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
              fontWeight: FontWeight.bold));
    });
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

    setState(() {
      _btnText = Text("Scan Again",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
              fontWeight: FontWeight.bold));
    });
  }

  void findDescriptors(BluetoothCharacteristic charact) async {
    var descriptor = charact.descriptors;
    for (BluetoothDescriptor d in descriptor) {
      List<int> value = await d.read();
      print("Descriptors: $value");
    }
  }

  void findCaracteristics(BluetoothService service) async {
    var characteristics = service.characteristics;

    for (BluetoothCharacteristic c in characteristics) {
      print("c:   ${c.uuid}");
      if (c.uuid.toString() == Guid("0002a3700001000800000805f9b34fb")) {
        // TODO: Perguntar se não dá pra substituir esse Guid pela string simples
        var val = c.read(); // Não usada
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
      _deviceConnectionInfo = "Connecting...";
      device = dev;
      deviceConnected_name = device.name;
    });

    await device
        .connect(timeout: Duration(seconds: 10))
        .timeout(Duration(seconds: 10), onTimeout: () {
      setState(() {
        _deviceConnectionInfo = "Connect";
      });
      returnValue = Future.value(false);
    }).then((data) {
      if (returnValue == null) {
        isConnected = true;

        findServices(dev);
        List<List> values = [];

        setState(() {
          _deviceConnectionInfo = "Connected";
        });

        print("Connection successful!");
      }
    });
  }

  disconnect() async {
    await device.disconnect();
    setState(() {
      deviceConnected_name = " ";
      device = null;
      _deviceConnectionInfo = "Connect";
      isConnected = false;
    });
  }

  _readInfoFromDevice(List values) async {
    print(values);
    if (values.length > 0) {
      globals.heartRate_global = await values[1];
      print("value: ${values[1]}");
      print("valor da global ${globals.heartRate_global.toString()}");
      setState(() {
        heartRate = values[1];
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
    return Scaffold(
        body: Container(
      padding: EdgeInsets.fromLTRB(10, 70, 10, 10),
      height: 600,
      child: Wrap(
        runSpacing: 6.0,
        direction: Axis.horizontal,
        children: [
          SizedBox(height: 10.0),
          Container(
            alignment: Alignment(0.0, 0.6),
            child: isConnected
                ? Text(
                    'Connected to \n' + deviceConnected_name,
                    style: TextStyle(fontSize: 28.0, color: Color(0xff16613D)),
                  )
                : //IMPORTANTE TER ISSO PORQUE É UMA CONDICAO NAO APAGAR
                Text(
                    'No Device Connected',
                    style: TextStyle(fontSize: 28.0, color: Color(0xff16613D)),
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
            child: heartRate == -1
                ? SizedBox()
                : //IMPORTANTE TER ISSO PORQUE É UMA CONDICAO NAO APAGAR
                Text(
                    'Heart Rate: ' + heartRate.toString(),
                    style: TextStyle(fontSize: 28.0, color: Color(0xff16613D)),
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
                onPressed: () async {
                  await scan();
                },
                child: _btnText,
              ),
            ),
          )),
        ],
      ),
    ));
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return InkWell(
        child: Card(
      child: Center(
        child: Column(children: <Widget>[
          SizedBox(
            height: 15,
          ),
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
            child: Text(_deviceConnectionInfo),
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
                        _readCharacteristics();
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
