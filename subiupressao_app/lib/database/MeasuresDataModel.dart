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

}