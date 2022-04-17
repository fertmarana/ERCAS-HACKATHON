import 'dart:convert';

import 'package:subiupressao_app/files/models/appointment.dart';
import 'package:subiupressao_app/files/models/bloodPressure.dart';
import 'package:subiupressao_app/files/models/medicine.dart';

class User {
  // Vital data
  String name;
  int age;
  int weight;
  int height;
  List<Medicine> medicines;
  List<Appointment> appointments;

  // Non-vital data
  DateTime birth;
  String cpf;
  String healthInsurance;
  String cardiacSituation;

  // Historical data
  BloodPressure bloodPressure;
  List<int> dayHeartRate;
  List<int> monthHeartRate;

  User({
    this.name,
    this.age,
    this.weight,
    this.height,
    this.medicines,
    this.appointments,
    birth,
    this.cpf = '',
    this.healthInsurance = '',
    this.cardiacSituation = '',
    dayHeartRate,
    monthHeartRate,
    dayBloodPressure,
    monthBloodPressure,
  })  : this.birth = birth ?? DateTime(0),
        this.dayHeartRate = dayHeartRate ?? [];

  User.fromJson(Map<String, dynamic> json) {
    dynamic jsonResponse;

    name = json['name'];
    age = json['age'];
    weight = json['weight'];
    height = json['height'];

    birth = DateTime.parse(json['birth']);
    cpf = json['cpf'];
    healthInsurance = json['healthInsurance'];
    cardiacSituation = json['cardiacSituation'];

    jsonResponse = jsonDecode(json['medicines']);
    medicines =
        jsonResponse.map<Medicine>((jR) => Medicine.fromJson(jR)).toList();

    jsonResponse = jsonDecode(json['appointments']);
    appointments = jsonResponse
        .map<Appointment>((jR) => Appointment.fromJson(jR))
        .toList();

    dayHeartRate = json['dayHeartRate'].cast<int>();
    monthHeartRate = json['monthHeartRate'].cast<int>();
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'age': age,
        'weight': weight,
        'height': height,
        'medicines': jsonEncode(medicines),
        'appointments': jsonEncode(appointments),
        'birth': birth.toString(),
        'cpf': cpf,
        'healthInsurance': healthInsurance,
        'cardiacSituation': cardiacSituation,
        'dayHeartRate': dayHeartRate,
        'monthHeartRate': monthHeartRate,
      };

  User copyUser() => User(
        name: this.name,
        age: this.age,
        weight: this.weight,
        height: this.height,
        medicines: this.medicines,
        appointments: this.appointments,
        birth: this.birth,
        cpf: this.cpf,
        healthInsurance: this.healthInsurance,
        cardiacSituation: this.cardiacSituation,
        dayHeartRate: this.dayHeartRate,
        monthHeartRate: this.monthHeartRate,
      );
}
