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

  int _currentPage = 0;
  var controller = PageController(
    viewportFraction: 1 ,
    initialPage: 0,
  );

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

  ///// **** Scan and Stop Bluetooth Methods  ***** /////
  void scanForDevices() async {
    flutterBlue.startScan(timeout: Duration(seconds: 4));
    var subscription = flutterBlue.scan().listen((scanResult) async {
      if (scanResult.device.name == "Amazfit Band 5") {
        print("found device");
//Assigning bluetooth device
        device = scanResult.device;
//After that we stop the scanning for device
      }


    //
    /*
    // Listen to scan results
    var subscription = flutterBlue.scanResults.listen((results) {
      // do something with scan results
      for (ScanResult r in results) {
        print('${r.device.name} found! rssi: ${r.rssi}');
      }
    });
  */

      });
      // Stop scanning
        flutterBlue.stopScan();




  }






  @override
  Widget build(BuildContext context) {
    return Container();
  }



}