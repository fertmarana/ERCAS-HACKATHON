import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:subiupressao_app/globals.dart' as globals;
import 'connectionPage.dart';
import 'package:subiupressao_app/dataClass.dart';

class heartRatePage extends StatefulWidget {
 //

  heartRatePage({Key key, @required this.dat}) : super(key: key);
  final myData dat;
  //heartRatePage(this.Heartrate, this.callback);

  //heartRatePage({Key key, @required this.promise}) : super(key: key);

  @override
  _heartRatePage createState() => _heartRatePage();
}

class _heartRatePage extends State<heartRatePage> {
  int hr;

  @override
  void initState() {
    super.initState();

  }

  void find_hearRate() async{
    final int h = await globals.heartRate_global;
    hr = h;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(10, 70, 10, 10),
    child: Wrap(
    runSpacing: 6.0,
    direction: Axis.horizontal,
    children: [
      /*
      Container(
        alignment: Alignment(0.0, 0.6),
        child: FutureBuilder(
          future: this.promise,
          builder: (BuildContext context, AsyncSnapshot snapshot){
            return Text('Heart Rate: ' + snapshot.data.toString(),
                style: TextStyle(
                fontSize: 28.0,
                color: Color(0xff16613D)
                ),
                );
          },
        )
      ),
      */
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
                  find_hearRate();
                },
                child:
                Text("Update",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18.0,color: Colors.white, fontWeight: FontWeight.bold)
                ),
              ),
            ),
          )
      ),
    ])
    );
  }


}