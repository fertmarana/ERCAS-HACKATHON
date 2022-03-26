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


  @override
  void initState() {
    // TODO: implement initState
    isConnected = false;
    super.initState();
    initBluetoothScanning();
    heartRate = -1;
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
      if(c.uuid.toString() == Guid("0002a3700001000800000805f9b34fb")){
        var val = c.read();
        //List<int> values = c.lastValue;
          print("Oiiiii");
          print("Printandoo valor ${val}");



      }
      List<int> value = await c.read();
      print("Characteristic: ${value}");

    }
  }

  void findServices(BluetoothDevice dev) async {

    List<BluetoothService> services = await dev.discoverServices();
    services.forEach((service) {
      // do something with service
      print("foiiiii");
      if(service.uuid.toString() == "0000180d-0000-1000-8000-00805f9b34fb"){
        print("UUID SERVICE: ${service.uuid.toString()}");
        //findCaracteristics(service);
        service.characteristics.forEach((element) {
          print("Characteristic uuid: ${element.uuid}");
          //if(element.uuid.toString() == "0002a37-0000-1000-8000-00805f9b34fb"){
          if(element.uuid.toString() == CHARACTERISTIC_UUID){
            print("é sim");

            characteristicBluetooth = element;
            print(element.value);
            //Future<List<int>> _futureOfList = element.read();
            //List<int> list = await _futureOfList ;


          }
         // listStream = element.value;
         // element.setNotifyValue(!element.isNotifying);
        });
      }


    });
  }

  void connectDevice(BluetoothDevice dev) async{
    setState(() {
      device = dev;
      deviceConnected_name = device.name;

    });
    await device.connect() ;
    isConnected = true;
    findServices(dev); List<List> values = [];
  }


  disconnect() async{

    await device.disconnect();
    setState(() {
      deviceConnected_name = " ";
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

    //notifyListeners();
  }


  /*
  interpretReceivedData(String data) async {
    if (data == "abt_HANDS_SHAKE") {//Do something here or send next command to device
    sendTransparentData('Hello');
    } else {
      print("Determine what to do with $data");
    }
  }
  */






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
            child: Text('Conected to ' + deviceConnected_name,
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

                  color: Colors.red,
                  child: MaterialButton(

                    minWidth: 200.0,
                    padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    onPressed: () {
                      //scanForDevices();
                      scan();

                    },
                    child: Text("Disconnect all",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20.0,color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),

              )
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
          StreamBuilder<List<int>>(
            stream: listStream,
            initialData: [],
            builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
              if (snapshot.connectionState == ConnectionState.active){
              interpretReceivedData(currentValue);
              return Center(child: Text('We are finding the data..'));}
              else {
                return SizedBox();}
              },
            );
            */

          /*
          StreamBuilder<BluetoothState>(
              stream: FlutterBlue.instance.state,
              initialData: BluetoothState.unknown,
              builder: (c, snapshot) {
                final state = snapshot.data;listStream.elementAt(1);
    for(var dev in flutterBlue.connectedDevices.toString()){
                if (state == BluetoothState.on) {
                  return FindDevicesScreen();
                }
                return BluetoothOffScreen(state: state);
              }),
          */
      StreamBuilder<List<int>>(
        stream: listStream,  //here we're using our char's value
        initialData: [],
        builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
          if (snapshot.connectionState == ConnectionState.active)
          {//In this method we'll interpret received data
            //interpretReceivedData(currentValue);
            //print(listStream.elementAt(1).toString());
            return Center(child: Text('We are finding the data..' + heartRate.toString() , ));
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
      onTap: (){
        if(isConnected){
          findServices(device);
          _readCharacteristics();
          print("heartRate: ${heartRate}");
          //values.add(await element.read());
        }else{
          print("Conectandoooo ${scanResultList[index].device.name}");
          connectDevice(scanResultList[index].device);

        }



     },
    );
  }



}