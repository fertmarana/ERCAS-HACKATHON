import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter/material.dart';
import 'dart:async';

// UUIDS DOS SERVICOS QUE VAMOS USAR
/*
0002a37-0000-1000-8000-00805f9b34fb"), "Heart Rate Measurement");
00002a39-0000-1000-8000-00805f9b34fb"), "Heart Rate Control Point");
"00002a49-0000-1000-8000-00805f9b34fb"), "Blood Pressure Feature");
"00002a35-0000-1000-8000-00805f9b34fb"), "Blood Pressure Measurement");

*/
class BluetoothTesting extends StatefulWidget {
  @override
  _BluetoothTesting createState() => _BluetoothTesting();
}

class _BluetoothTesting extends State<BluetoothTesting> {
  BluetoothService _service;
  BluetoothDevice device;
  BluetoothState state;
  BluetoothCharacteristic characteristicBluetooth;
  BluetoothDeviceState deviceState;
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<ScanResult> scanResultList = [];
  Stream<List<int>> listStream;
  bool _isScanning = true;
  final Map<Guid, List<int>> readValues = new Map<Guid, List<int>>();
  String deviceConnectedName = "";
  static const CHARACTERISTIC_UUID = "00002a37-0000-1000-8000-00805f9b34fb";
  bool isConnected;
  int heartRate;

  @override
  void initState() {
    isConnected = false;
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
    if (!_isScanning) {
      scanResultList.clear();
      flutterBlue.startScan(timeout: Duration(seconds: 4));

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

  Widget deviceSignal(ScanResult r) {
    return Text(r.rssi.toString());
  }

  Widget deviceMacAddress(ScanResult r) {
    return Text(r.device.id.id);
  }

  void scanForDevicesGeneral() async {
    flutterBlue.startScan(timeout: Duration(seconds: 49));
    var subscription = flutterBlue.scanResults.listen((results) {
      // do something with scan results
      for (ScanResult r in results) {
        print('${r.device.name} found! id: ${r.device.id}');
      }
    });

    // Stop scanning
    flutterBlue.stopScan();
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
    services.forEach((service) {
      // do something with service
      if (service.uuid.toString() == "0000180d-0000-1000-8000-00805f9b34fb") {
        print("UUID SERVICE: ${service.uuid.toString()}");

        service.characteristics.forEach((element) {
          print("Characteristic uuid: ${element.uuid}");
          if (element.uuid.toString() == CHARACTERISTIC_UUID) {
            characteristicBluetooth = element;
            print(element.value);
          }
        });
      }
    });
  }

  void connectDevice(BluetoothDevice dev) async {
    setState(() {
      device = dev;
      deviceConnectedName = device.name;
    });

    await device.connect();
    isConnected = true;
    findServices(dev);
  }

  disconnect() async {
    await device.disconnect();
    setState(() {
      deviceConnectedName = " ";
      device = null;
      isConnected = false;
    });
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
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        size.width * 0.03,
        size.height * 0.1,
        size.width * 0.03,
        size.height * 0.015,
      ),
      child: Wrap(
        runSpacing: 6.0,
        direction: Axis.horizontal,
        children: [
          SizedBox(height: size.height * 0.015),
          Container(
            alignment: Alignment(0.0, 0.6),
            child: Text(
              'Bluetooth',
              style: TextStyle(fontSize: 28.0, color: Color(0xff16613D)),
            ),
          ),
          Container(
            alignment: Alignment(0.0, 0.6),
            child: Text(
              'Conected to ' + deviceConnectedName,
              style: TextStyle(fontSize: 28.0, color: Color(0xff16613D)),
            ),
          ),
          Container(
              child: Align(
            alignment: Alignment.center,
            child: Material(
              borderRadius: BorderRadius.circular(30.0),
              color: Colors.red,
              child: MaterialButton(
                minWidth: size.width * 0.55,
                padding: EdgeInsets.fromLTRB(
                  size.width * 0.05,
                  size.height * 0.02,
                  size.width * 0.05,
                  size.height * 0.02,
                ),
                onPressed: () {
                  scan();
                },
                child: Text("Disconnect all",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          )),
          Container(
              child: Align(
            alignment: Alignment.center,
            child: Material(
              borderRadius: BorderRadius.circular(30.0),
              color: Color(0xFF009E74),
              child: MaterialButton(
                minWidth: size.width * 0.55,
                padding: EdgeInsets.fromLTRB(
                  size.width * 0.05,
                  size.height * 0.02,
                  size.width * 0.05,
                  size.height * 0.02,
                ),
                onPressed: () {
                  //scanForDevices();
                  scan();
                },
                child: Text("Scanning",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          )),
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
          StreamBuilder<List<int>>(
            stream: listStream, //here we're using our char's value
            initialData: [],
            builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                //In this method we'll interpret received data

                return Center(
                    child: Text(
                  'We are finding the data..' + heartRate.toString(),
                ));
              } else {
                return SizedBox();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return InkWell(
      child: Card(
        child: Center(
          child: Text(
            "${scanResultList[index].device.name}",
            style: TextStyle(
              fontSize: 28.0,
              color: Colors.orange,
            ),
          ),
        ),
      ),
      onTap: () {
        if (isConnected) {
          findServices(device);
          _readCharacteristics();
          print("heartRate: $heartRate");
          //values.add(await element.read());
        } else {
          print("Conectandoooo ${scanResultList[index].device.name}");
          connectDevice(scanResultList[index].device);
        }
      },
    );
  }
}
