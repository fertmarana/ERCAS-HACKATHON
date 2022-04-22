import 'package:intl/intl.dart';

class BloodPressure {
  BloodPressure({this.systolic, this.diastolic, DateTime time}) {
    // this.time = time == null ? DateTime.now() : time;
  }

  int systolic;
  int diastolic;
  // DateTime time;

  @override
  String toString() => '$systolic/$diastolic';

  BloodPressure.fromJson(Map<String, dynamic> json)
      : systolic = json['systolic'],
        diastolic = json['diastolic'];
  // time = DateTime.parse(json['time']);

  Map<String, dynamic> toJson() => {
        'systolic': systolic,
        'diastolic': diastolic,
        // 'time': time.toString(),
      };
}
