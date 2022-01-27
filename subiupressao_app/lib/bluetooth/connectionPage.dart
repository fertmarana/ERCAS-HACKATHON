import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:subiupressao_app/app.dart';
import 'package:subiupressao_app/globals.dart' as globals;
import 'dart:async';
import 'dart:core';
import 'package:syncfusion_flutter_charts/charts.dart';

// UUIDS DOS SERVICOS QUE VAMOS USAR
/*
0002a37-0000-1000-8000-00805f9b34fb"), "Heart Rate Measurement");
00002a39-0000-1000-8000-00805f9b34fb"), "Heart Rate Control Point");
"00002a49-0000-1000-8000-00805f9b34fb"), "Blood Pressure Feature");
"00002a35-0000-1000-8000-00805f9b34fb"), "Blood Pressure Measurement");

*/
class connectionPage extends StatefulWidget {
 // int Heartrate;
  //Function(int) callback;
  //connectionPage(this.Heartrate, this.callback);

  //connectionPage({Key key, @required this.Heartrate,this.callback}) : super(key: key);

  @override
  _connectionPage createState() => _connectionPage();
}

class _ChartData{
  int minute;
  int epoch;
  _ChartData(this.minute, this.epoch);
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
  int greatestValue = 0;
  int valuesofHeart = -1;
  List<_ChartData> chartData = <_ChartData>[];
  ChartSeriesController _chartSeriesController;
  Timer timer;

  @override
  void initState() {
    // TODO: implement initState
    isConnected = false;
    /*Timer.periodic(Duration(minutes: 1), (Timer t) => setState((){
      greatestValue = valuesofHeart;
      valuesofHeart = -1;

    }));*/

    heartRate = -1;
    super.initState();
    initBluetoothScanning();

  }

  void _updateDataSource(Timer timer) {
    greatestValue = valuesofHeart;
    valuesofHeart = -1;
    chartData.add(_ChartData(DateTime.now().minute.toInt(), greatestValue ));
    if (chartData.length == 20) {
      // Removes the last index data of data source.
      chartData.removeAt(0);
      int len = chartData.length.toInt() -1;
      // Here calling updateDataSource method with addedDataIndexes to add data in last index and removedDataIndexes to remove data from the last.
      _chartSeriesController?.updateDataSource(addedDataIndexes: <int>[(len)],
          removedDataIndexes: <int>[0]);
    }

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
    for (BluetoothService service in services) {
      // do something with service
      print("foiiiii");
      if(service.uuid.toString() == "0000180d-0000-1000-8000-00805f9b34fb") {
        print("UUID SERVICE: ${service.uuid.toString()}");
        //findCaracteristics(service);
        for (BluetoothCharacteristic element in service.characteristics) {
          //service.characteristics.forEach((element) {
          print("Characteristic uuid: ${element.uuid}");
          //if(element.uuid.toString() == "0002a37-0000-1000-8000-00805f9b34fb"){
          if (element.uuid.toString() == CHARACTERISTIC_UUID) {
            print("é sim");
            _readthisCharacteristic(element);

            characteristicBluetooth = element;

            print(element.value);
            //Future<List<int>> _futureOfList = element.read();
            //List<int> list = await _futureOfList ;


          }
          // listStream = element.value;
          // element.setNotifyValue(!element.isNotifying);
        }

      }


    }
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
  _readInfoFromDevice(List values) async{
    if(values.length>0){
      globals.heartRate_global = await values[1];
      print("value: ${values[1]}");
      print("valor da global ${globals.heartRate_global.toString()}");
      setState(() {
        heartRate = values[1];
        if(heartRate > valuesofHeart){
          valuesofHeart = heartRate;
        }
        //globals.heartRate_global = values[1];
       // widget.callback(heartRate);
      });

    }else{
      print("ta vazio");
    }
  }

  void _readthisCharacteristic(BluetoothCharacteristic c) async {
    List<int> values = [];
    print("to aqui");
    if(c.properties.read){
      print("ele le");
    }
    if (c != null ) {
      print("tentando ler");
      await c.setNotifyValue(true);
      c.value.listen((value) {
        _readInfoFromDevice(value);
      });


      /*if(isReading == false){
        isReading = true;
        values= await c.read();
        isReading = false;
        //print("VALUES:${values.length} ");
        print("values = $values");
        }
      */
      }

    //heartRate = values[0];

    //notifyListeners();
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







  @override
  Widget build(BuildContext context) {
    timer = Timer.periodic(const Duration(minutes: 1), _updateDataSource);
    return Scaffold(
        body: Container(
        padding: EdgeInsets.fromLTRB(10, 70, 10, 10),
        height: 800,
        child: ListView(
          //runSpacing: 6.0,
          //direction: Axis.horizontal,
          children: [
            SizedBox(height: 10.0),
            Container(
              alignment: Alignment(0.0, 0.6),
              child: isConnected ?
              Text('Connected to \n' + deviceConnected_name,
                style: TextStyle(
                    fontSize: 28.0,
                    color: Color(0xff16613D)
                ),
              )
                  : //IMPORTANTE TER ISSO PORQUE É UMA CONDICAO NAO APAGAR
              Text('No Device Connected',
                style: TextStyle(
                    fontSize: 28.0,
                    color: Color(0xff16613D)
                ),
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
              child: heartRate == -1?
              SizedBox()
                  : //IMPORTANTE TER ISSO PORQUE É UMA CONDICAO NAO APAGAR
              Text('Heart Rate: ' + heartRate.toString(),
                style: TextStyle(
                    fontSize: 28.0,
                    color: Color(0xff16613D)
                ),
              ),

            ),
            Container(
              alignment: Alignment(0.0, 0.6),
              child: heartRate == -1?
              SizedBox()
                  : //IMPORTANTE TER ISSO PORQUE É UMA CONDICAO NAO APAGAR
              Text('Date Time: ' + DateTime.now().minute.toString(),
                style: TextStyle(
                    fontSize: 28.0,
                    color: Color(0xff16613D)
                ),
              ),

            ),
            Container(
              alignment: Alignment(0.0, 0.6),
              child: heartRate == -1?
              SizedBox()
                  : //IMPORTANTE TER ISSO PORQUE É UMA CONDICAO NAO APAGAR
              Text('Greatest Value this minute: ' + greatestValue.toString(),
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
                      child:
                      isConnected ?

                      Text("Scan Again",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20.0,color: Colors.white, fontWeight: FontWeight.bold)
                      ):
                      Text("Scan for Devices",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18.0,color: Colors.white, fontWeight: FontWeight.bold)
                      )

                      ,
                    ),
                  ),

                )
            ),
            Container(
              child: SfCartesianChart(
                title: ChartTitle(text: "Heart Measure per Minute"),
                enableAxisAnimation: true,
                primaryXAxis: NumericAxis(
                  // Edge labels will be shifted
                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                    interval: 10,
                    /*
                    majorTickLines: MajorTickLines(
                        size: 6,
                        width: 1,
                        color: Colors.blue
                    ),
                    */

                ),
                //legend: Legend(isVisible: true),
                series: <LineSeries<_ChartData, int>>[
                  LineSeries<_ChartData, int>(
                    onRendererCreated: (ChartSeriesController controller) {
                      // Assigning the controller to the _chartSeriesController.
                      _chartSeriesController = controller;

                    },


                    // Binding the chartData to the dataSource of the line series.
                    //name: "Heart Measure",
                    dataSource: chartData,
                    xValueMapper: (_ChartData data, _) => data.minute,
                    yValueMapper: (_ChartData data, _) => data.epoch,
                  )
                ],
               // primaryXAxis: NumericAxis(edgeLabelPlacement: EdgeLabelPlacement.shift, numberFormat: NumberFormat.simpleCurrency(decimalDigits: 0)),
              ),
            ),
            /*
            Container(
                child: Align(
                  alignment: Alignment.center,
                  child:
                  isConnected?
                  Material(
                    borderRadius: BorderRadius.circular(30.0),
                    color: Color(0xFF009E74),
                    child: MaterialButton(
                      minWidth: 200.0,
                      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => App()),
                        );
                      },
                      child:
                      Text("Continue",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18.0,color: Colors.white, fontWeight: FontWeight.bold)
                      )

                      ,
                    ),
                  ):
                  SizedBox(),

                )
            ),*/
            /*
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
            ),*/

          ],
        ),
      )
    );
  }


  Widget _itemBuilder(BuildContext context, int index) {
    return InkWell(
      child: Card(
        child: Center(
          child: Column(
            children: <Widget>[

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
                child: isConnected ?
                TextButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  onPressed: () {
                    findServices(device);
                    _readCharacteristics();

                  },
                  child: Text('Read Heart Rate'),
                )
                    : //IMPORTANTE TER ISSO PORQUE É UMA CONDICAO NAO APAGAR
                SizedBox()

              ),
    ]
        ),
      ),

                /*onTap: (){
        if(isConnected){
          findServices(device);
          _readCharacteristics();
          print("heartRate: ${heartRate}");
          //values.add(await element.read());
        }else{
          print("Conectandoooo ${scanResultList[index].device.name}");


        }



      },*/
    ));
  }

}