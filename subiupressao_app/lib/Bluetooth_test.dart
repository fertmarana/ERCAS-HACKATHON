import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class Bluetooth_testing extends StatefulWidget {
  @override
  _Bluetooth_testing createState() => _Bluetooth_testing();
}

class _Bluetooth_testing extends State<Bluetooth_testing> {
  BluetoothDevice device;
  BluetoothState state;
  BluetoothDeviceState deviceState;
  StreamSubscription<BluetoothState> scanSubscription;
  FlutterBlue flutterBlue = FlutterBlue.instance;

  @override
  void initState() {
    super.initState();
    //checks bluetooth current state
    scanSubscription = flutterBlue.state.listen((state) {
      if (state == BluetoothState.off) {
//Alert user to turn on bluetooth.
      } else if (state == BluetoothState.on) {
//if bluetooth is enabled then go ahead.
//Make sure user's device gps is on.
        scanForDevices();
      }
    });
  }
/*
  void scanForDevices() async {
    flutterBlue.startScan(timeout: Duration(seconds: 30));
    var subscription = flutterBlue.scanResults.listen((results) {
      // do something with scan results
      for (ScanResult r in results) {
        print('${r.device.name} found! rssi: ${r.rssi}');
      }
    });

  // Stop scanning
  flutterBlue.stopScan();

  }
  */


  ///// **** Scan and Stop Bluetooth Methods  ***** /////
  void scanForDevices() async {
    flutterBlue.startScan(timeout: Duration(seconds: 30));
    var subscription = flutterBlue.scan().listen((scanResult) async {
      if (scanResult.device.name == "Amazfit Band 5") {
        print("found device");
//Assigning bluetooth device
        device = scanResult.device;
//After that we stop the scanning for device
      }
     });
      // Stop scanning
    flutterBlue.stopScan();
    await device.connect();
    List<BluetoothService> services = await device.discoverServices();
   // services.forEach((service) {
      for (var service in services) {
      // do something with service
      print('${device.name} has service of: ${service.characteristics}');
    }

  }






  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 70, 10, 10),
      child: Wrap(
        runSpacing: 6.0,
        direction: Axis.horizontal,
        children: [
          SizedBox(height: 10.0),
          Container(
            alignment: Alignment(0.0, 0.6),
            child: Text('Bluetooth',
              style: TextStyle(
                  fontSize: 28.0,
                  color: Color(0xff16613D)
              ),
            ),
          ),
          Container(
            alignment: Alignment(0.0, 0.6),
            child: Text('Conected to \n' + device.name,
              style: TextStyle(
                  fontSize: 28.0,
                  color: Color(0xff16613D)
              ),
            ),
          ),
          Container(
            alignment: Alignment(0.0, 0.6),
            child: Text('Conected to \n' + device.name,
              style: TextStyle(
                  fontSize: 28.0,
                  color: Color(0xff16613D)
              ),
            ),
          ),
        ],
      ),
    );
  }


}