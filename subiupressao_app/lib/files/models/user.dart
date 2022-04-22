import 'dart:convert';

import 'package:subiupressao_app/files/models/appointment.dart';
import 'package:subiupressao_app/files/models/bloodPressure.dart';
import 'package:subiupressao_app/files/models/gender.dart';
import 'package:subiupressao_app/files/models/medicine.dart';

class User {
  // Vital data
  String name;
  DateTime birth;
  int weight;
  int height;
  int age;
  List<Medicine> medicines;
  List<Appointment> appointments;
  Gender gender;

  // Non-vital data
  String cpf;
  String healthInsurance;
  String cardiacSituation;

  // Historical data
  BloodPressure bloodPressure;
  List<int> dayHeartRate;
  List<int> monthHeartRate;
  // Map<DateTime, BloodPressure> dayBloodPressure;
  List<BloodPressure> dayBloodPressure;
  List<BloodPressure> monthBloodPressure;

  int _calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;

    if (month2 > month1) {
      age--;
    } else if (month2 == month1) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;

      if (day2 > day1) {
        age--;
      }
    }

    return age;
  }

  Gender _stringToGender(String str) {
    return Gender.values.firstWhere((e) => e.name == str);
  }

  User({
    this.name,
    this.weight,
    this.height,
    this.medicines,
    this.appointments,
    this.birth,
    this.cpf = '',
    this.healthInsurance = '',
    this.cardiacSituation = '',
    String gender,
    List<int> dayHeartRate,
    List<int> monthHeartRate,
    List<BloodPressure> dayBloodPressure,
    List<BloodPressure> monthBloodPressure,
    BloodPressure bloodPressure,
  }) {
    this.gender = _stringToGender(gender);
    this.dayHeartRate = dayHeartRate ?? [];
    this.monthHeartRate = monthHeartRate ?? [];
    this.dayBloodPressure = dayBloodPressure ?? [];
    this.monthBloodPressure = monthBloodPressure ?? [];
    this.bloodPressure =
        bloodPressure ?? BloodPressure(systolic: -1, diastolic: -1);
    this.age = _calculateAge(this.birth);
  }

  User.fromJson(Map<String, dynamic> json) {
    dynamic jsonResponse;

    this.name = json['name'];
    this.age = json['age'];
    this.weight = json['weight'];
    this.height = json['height'];
    this.gender = _stringToGender(json['gender']);

    this.birth = DateTime.parse(json['birth']);
    this.cpf = json['cpf'];
    this.healthInsurance = json['healthInsurance'];
    this.cardiacSituation = json['cardiacSituation'];

    jsonResponse = jsonDecode(json['medicines']);
    this.medicines =
        jsonResponse.map<Medicine>((jR) => Medicine.fromJson(jR)).toList();

    jsonResponse = jsonDecode(json['appointments']);
    this.appointments = jsonResponse
        .map<Appointment>((jR) => Appointment.fromJson(jR))
        .toList();

    this.bloodPressure =
        BloodPressure.fromJson(jsonDecode(json['bloodPressure']));

    this.dayHeartRate = jsonDecode(json['dayHeartRate']).cast<int>();
    this.monthHeartRate = jsonDecode(json['monthHeartRate']).cast<int>();

    jsonResponse = jsonDecode(json['dayBloodPressure']);
    this.dayBloodPressure = jsonResponse
        .map<BloodPressure>((jR) => BloodPressure.fromJson(jR))
        .toList();

    jsonResponse = jsonDecode(json['monthBloodPressure']);
    this.monthBloodPressure = jsonResponse
        .map<BloodPressure>((jR) => BloodPressure.fromJson(jR))
        .toList();
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'age': age,
        'weight': weight,
        'height': height,
        'gender': gender.name,
        'medicines': jsonEncode(medicines),
        'appointments': jsonEncode(appointments),
        'birth': birth.toString(),
        'cpf': cpf,
        'healthInsurance': healthInsurance,
        'cardiacSituation': cardiacSituation,
        'bloodPressure': jsonEncode(bloodPressure),
        'dayHeartRate': jsonEncode(dayHeartRate),
        'monthHeartRate': jsonEncode(monthHeartRate),
        'dayBloodPressure': jsonEncode(dayBloodPressure),
        'monthBloodPressure': jsonEncode(monthBloodPressure),
      };

  User copyUser() => User(
        name: this.name,
        weight: this.weight,
        height: this.height,
        gender: this.gender.name,
        medicines: this.medicines,
        appointments: this.appointments,
        birth: this.birth,
        cpf: this.cpf,
        healthInsurance: this.healthInsurance,
        cardiacSituation: this.cardiacSituation,
        dayHeartRate: this.dayHeartRate,
        monthHeartRate: this.monthHeartRate,
        bloodPressure: this.bloodPressure,
        dayBloodPressure: this.dayBloodPressure,
        monthBloodPressure: this.monthBloodPressure,
      );
}
