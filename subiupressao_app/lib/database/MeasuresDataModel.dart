import 'dart:convert';
import 'dart:core';

import 'package:flutter/cupertino.dart';

Heart heartFromJson(String str) {
  final jsonData = json.decode(str);
  return Heart.fromMap(jsonData);
}

String heartToJson(Heart data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Heart {
  int id;
  //String dateTime;

  int heartRate;
  //int dateTime;
  DateTime dateTime;

  Heart({
    this.id,
    //
    this.heartRate,
    this.dateTime,
  });

  factory Heart.fromMap(Map<String, dynamic> json) => new Heart(
    id: json["id"],
    //
    heartRate: json["heartRate"],
    dateTime: DateTime.parse(json["dateTime"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,

  //  "dateTime": dateTime,
    "heartRate": heartRate,
    "dateTime": dateTime.toIso8601String(),
  };


  @override
  String toString() {
   // return 'Heart{id: $id, heart: $heartRate, dateTime: $dateTime}';
    return 'Heart{id: $id, heart: $heartRate, dateTime: $dateTime}';
  }

  String toStringHeart() {
    // return 'Heart{id: $id, heart: $heartRate, dateTime: $dateTime}';
    return '$heartRate';
  }

  String toStringDateTime() {
    // return 'Heart{id: $id, heart: $heartRate, dateTime: $dateTime}';

    return '$dateTime';
  }

  int get_hearetRate(){
    return heartRate;
  }
  String toStringdateTime_minute(){
    if(dateTime.minute< 10) return "0" + dateTime.minute.toString();
    return dateTime.minute.toString();
  }
  String toStringdateTime_second(){
    if(dateTime.second< 10) return "0" + dateTime.second.toString();
    return dateTime.second.toString();
  }
  String toStringdateTime_hour(){
    if(dateTime.hour< 10) return "0" + dateTime.hour.toString();
    return dateTime.hour.toString();
  }
  String toStringdateTime_day(){
    if(dateTime.day< 10) return "0" + dateTime.day.toString();
    return dateTime.day.toString();
  }
  String toStringdateTime_month(){
    if(dateTime.month< 10) return "0" + dateTime.month.toString();
    return dateTime.month.toString();
  }
  String toStringdateTime_year(){
    if(dateTime.year< 10) return "0" + dateTime.year.toString();
    return dateTime.year.toString();
  }

}