import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:toast/toast.dart';

class Bluetooth_page extends StatefulWidget {
  Bluetooth_page({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _Bluetooth_page createState() => _Bluetooth_page();
}

class _Bluetooth_page extends State<Bluetooth_page> {
  FlutterBlue flutterBlue = FlutterBlue.instance;

  List<BluetoothDevice> devices = [];

  List<BluetoothService> services = [];
  BluetoothService myImportantService;
  List<BluetoothCharacteristic> characteristics = [];
  BluetoothCharacteristic myImportantCharacteristic;

  int counter = 10;

  @override
  void initState() {
    super.initState();

    discover();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void discover() async {
    List<ScanResult> res = await flutterBlue.startScan(
      timeout: Duration(seconds: 2),
      allowDuplicates: false,
      scanMode: ScanMode.balanced,
    );
    if ((await flutterBlue.connectedDevices).isNotEmpty) {
      await flutterBlue.connectedDevices.then(
            (value) => value.first.disconnect().then(
              (value) => Toast.show("BLE Disconnected", context),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OutlinedButton(
              onPressed: () async {
                devices.clear();
                Timer.periodic(Duration(seconds: 1), (t) {
                  setState(() {
                    if (counter > 0) {
                      counter--;
                    } else {
                      counter = 10;
                      t.cancel();
                    }
                  });
                });

                List<ScanResult> res = await flutterBlue.startScan(
                  timeout: Duration(seconds: 10),
                  allowDuplicates: false,
                  scanMode: ScanMode.balanced,
                );

                print(await flutterBlue.connectedDevices);

                res.forEach((element) {
                  print(element.device);
                  devices.add(element.device);
                });

                // try {
                //   await bluetooth.getBondedDevices().then((value) {
                //     setState(() {
                //       devices = value;
                //     });
                //   });
                // } on PlatformException {
                //   print("Can't connect");
                // }
              },
              child: Text(
                'Start Scannig Devices',
              ),
            ),
            Text(
              "$counter",
            ),
            Text(
              'Available Devices:',
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: devices.length,
                itemBuilder: (context, index) => InkWell(
                  onTap: () async {
                    // try {
                    //   if (bleConn == null) {
                    //     bleConn = await BluetoothConnection.toAddress(
                    //         devices[index].address);
                    //     setState(() {});

                    //     if (bleConn.isConnected) {
                    //       var data = await bleConn.output.allSent;
                    //       // bleConn.input.forEach((element) {
                    //       //   print(element.first.toString());
                    //       // });
                    //       Toast.show(
                    //         'BLE Connected. nData incoming: ${data.toString()}',
                    //         context,
                    //         duration: 10,
                    //       );
                    //       // Toast.show("BLE Connected", context);
                    //     }
                    //   } else {
                    //     bleConn.finish();
                    //     bleConn = null;
                    //     setState(() {});
                    //     Toast.show("BLE Disconnected", context, duration: 4);
                    //   }
                    // } on PlatformException {
                    //   Toast.show(
                    //       "Cannot connect due to: Platform Exception", context,
                    //       duration: 4);
                    // }
                    await devices[index].connect(autoConnect: false).then(
                          (value) => Toast.show("BLE Connected", context),
                    );

                    services = await devices[index].discoverServices();
                    for (BluetoothService s in services) {
                      //Would recommend to convert all to lowercase if comparing.
                      print(s.uuid);
                    }
                    print(await services[2].characteristics[0].read());
                    print(String.fromCharCodes(
                        await services[2].characteristics[0].read()));
                    // for (BluetoothService s in services) {
                    //   //Would recommend to convert all to lowercase if comparing.
                    //   print(s.uuid);
                    //   if (s.uuid.toString().toLowerCase() ==
                    //       "00002a53-0000-1000-8000-00805f9b34fb") {
                    //     myImportantService = s;
                    //     print(myImportantService.uuid);
                    //     characteristics = myImportantService.characteristics;
                    //     for (BluetoothCharacteristic c in characteristics) {
                    //       //Would recommend to convert all to lowercase if comparing.
                    //       // if(c.uuid.toString().toLowerCase() == CHARACTERISTIC_UUID)
                    //       //   myImportantCharacteristic = c;
                    //       print(c);
                    //     }
                    //   }
                    // }
                  },
                  onLongPress: () async {
                    // try {

                    // } catch (e) {
                    //   Toast.show(
                    //       "Cannot Disconnect due to: ${e.toString()}", context);
                    // }
                    await devices[index].disconnect().then(
                          (value) => Toast.show("BLE Disconnected", context),
                    );
                  },
                  child: Text(
                    "${devices[index].name}",
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}