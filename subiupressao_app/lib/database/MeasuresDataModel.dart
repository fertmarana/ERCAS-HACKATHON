import 'dart:convert';
import 'dart:core';

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
  int heartRate;
  DateTime dateTime;

  Heart({
    this.id,
    this.heartRate,
    this.dateTime,
  });

  factory Heart.fromMap(Map<String, dynamic> json) => new Heart(
        id: json["id"],
        heartRate: json["heartRate"],
        dateTime: DateTime.parse(json["dateTime"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "heartRate": heartRate,
        "dateTime": dateTime.toIso8601String(),
      };

  @override
  String toString() {
    return 'Heart{id: $id, heart: $heartRate, dateTime: $dateTime}';
  }

  String toStringHeart() {
    return '$heartRate';
  }

  String toStringDateTime() {
    return '$dateTime';
  }
}
