import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter/material.dart';

import 'package:subiupressao_app/globals.dart' as globals;
import 'connectionPage.dart';
import 'package:subiupressao_app/dataClass.dart';

class HeartRatePage extends StatefulWidget {
  HeartRatePage({Key key, @required this.dat}) : super(key: key);
  final myData dat;

  @override
  _HeartRatePage createState() => _HeartRatePage();
}

class _HeartRatePage extends State<HeartRatePage> {
  int hr;

  void findHearRate() {
    final int h = globals.heartRate_global;
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
                    findHearRate();
                  },
                  child: Text(
                    "Update",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
