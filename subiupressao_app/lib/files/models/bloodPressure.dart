class BloodPressure {
  BloodPressure({this.systolic, this.diastolic});

  int systolic;
  int diastolic;

  @override
  String toString() => '$systolic/$diastolic';

  BloodPressure.fromJson(Map<String, dynamic> json)
      : systolic = json['systolic'],
        diastolic = json['diastolic'];

  Map<String, dynamic> toJson() => {
        'systolic': systolic,
        'diastolic': diastolic,
      };
}
