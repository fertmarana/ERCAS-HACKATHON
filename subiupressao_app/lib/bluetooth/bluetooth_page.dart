import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:toast/toast.dart';

class BluetoothPage extends StatefulWidget {
  final String title;
  BluetoothPage({Key key, this.title}) : super(key: key);

  @override
  _BluetoothPage createState() => _BluetoothPage();
}

class _BluetoothPage extends State<BluetoothPage> {
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
                  },
                  onLongPress: () async {
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
