import 'dart:convert';

import 'package:subiupressao_app/files/models/appointment.dart';
import 'package:subiupressao_app/files/models/medicine.dart';

class User {
  String name;
  int age;
  int weight;
  int height;
  List<Medicine> medicines;
  List<Appointment> appointments;

  User({
    this.name,
    this.age,
    this.weight,
    this.height,
    this.medicines,
    this.appointments,
  });

  User.fromJson(Map<String, dynamic> json) {
    dynamic jsonResponse;

    name = json['name'];
    age = json['age'];
    weight = json['weight'];
    height = json['height'];

    jsonResponse = jsonDecode(json['medicines']);
    medicines =
        jsonResponse.map<Medicine>((jR) => Medicine.fromJson(jR)).toList();

    jsonResponse = jsonDecode(json['appointments']);
    appointments = jsonResponse
        .map<Appointment>((jR) => Appointment.fromJson(jR))
        .toList();
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'age': age,
        'weight': weight,
        'height': height,
        'medicines': jsonEncode(medicines),
        'appointments': jsonEncode(appointments),
      };

  @override
  String toString() {
    return ("User's name is $name, he/her age is $age and has ${medicines.length} medicines to take!");
  }

  User copyUser() => User(
        name: this.name,
        age: this.age,
        weight: this.weight,
        height: this.height,
        medicines: this.medicines,
        appointments: this.appointments,
      );
}
