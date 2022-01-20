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
  List<ScanResult> scanResultList = [];
  bool _isScanning = true;
  final Map<Guid, List<int>> readValues = new Map<Guid, List<int>>();

  /*
  @override
  void initState() {
    super.initState();
    //checks bluetooth current state
    flutterBlue.startScan(timeout: Duration(seconds: 49));
    scanSubscription = flutterBlue.state.listen((state) {
      if (state == BluetoothState.off) {
//Alert user to turn on bluetooth.
      } else if (state == BluetoothState.on) {
//if bluetooth is enabled then go ahead.
//Make sure user's device gps is on.
        scanForDevicesGeneral();
        scanForDevices();
      }
    });
  }*/

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initBluetoothScanning();
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
       // scanResultList = results;

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

  Widget deviceSignal(ScanResult r){
    return Text(r.rssi.toString());
  }

  Widget deviceMacAddress(ScanResult r){
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

  void findDescriptors(BluetoothCharacteristic charact) async{
    var descriptor = charact.descriptors;
    for(BluetoothDescriptor d in descriptor) {
      List<int> value = await d.read();
      print("Descriptors: ${value}");

    }
  }


  void findCaracteristics(BluetoothService service) async{
    var characteristics = service.characteristics;


     // setState(() {
     //   widget.readValues[characteristic.uuid] = value;
      //});

    for(BluetoothCharacteristic c in characteristics) {
      print("c:   ${c.uuid}");
      if(c.uuid.toString() == "0002a37-0000-1000-8000-00805f9b34fb"){
        var val = c.read();
        //List<int> values = c.lastValue;
          print("Oiiiii");
          print("Printandoo valor ${val}");



      }
      List<int> value = await c.read();
      print("Characteristic: ${value}");

    }
  }

  void findServices(BluetoothDevice dev) async{
    List<BluetoothService> services = await dev.discoverServices();
    services.forEach((service) {
      // do something with service
      print("foiiiii");
      if(service.uuid.toString() == "0000180d-0000-1000-8000-00805f9b34fb"){
        print("UUID SERVICE: ${service.uuid.toString()}");
        findCaracteristics(service);
      }


    });
  }

  void connectDevice(BluetoothDevice dev) async{
    setState(() {
      device = dev;


    });
    await device.connect() ;
    findServices(dev);
  }

  ///// **** Scan and Stop Bluetooth Methods  ***** /////
  void scanForDevices() async {
    //flutterBlue.startScan(timeout: Duration(seconds: 30));
    var subscription = flutterBlue.scan().listen((scanResult) async {
      if (scanResult.device.id == "F4:B0:0F:ED:98:06") {
        print("found device");
//Assigning bluetooth device
        device = scanResult.device;
//After that we stop the scanning for device
      }
     });
    /*
      // Stop scanningStreamBuilder<BluetoothState>(
      stream: FlutterBlue.instance.state,
      initialData: BluetoothState.unknown,
      builder: (c, snapshot) {
        final state = snapshot.data;
        if (state == BluetoothState.on) {synchronous suspension>
E/flutter (24269): #2      BluetoothDevice.conn
          return FindDevicesScreen();
        }
        return BluetoothOffScreen(state: state);
      }),*/

    /*
    await device.connect();
    flutterBlue.stopScan();
    List<BluetoothDevice> dev =tandoooo Amazfit Band 5 await flutterBlue.connectedDevices;
    dev.forEach((d) {
    print("Deviceeeeeeeeeeee ${d.name} ==>>>>>> ${d.id}");

    });

*/
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
            child: Text('Conected to ',
              style: TextStyle(
                  fontSize: 28.0,
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
                    child: Text("Scanning",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20.0,color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),

              )
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
          /*
          StreamBuilder<BluetoothState>(
              stream: FlutterBlue.instance.state,
              initialData: BluetoothState.unknown,
              builder: (c, snapshot) {
                final state = snapshot.data;
                if (state == BluetoothState.on) {
                  return FindDevicesScreen();
                }
                return BluetoothOffScreen(state: state);
              }),
          */
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
      onTap: (){
        print("Conectandoooo ${scanResultList[index].device.name}");
        connectDevice(scanResultList[index].device);

        

     },
    );
  }



}