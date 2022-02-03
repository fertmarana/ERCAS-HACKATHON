import 'dart:convert';

import 'package:subiupressao_app/files/models/medicine.dart';

class User {
  String name;
  int age;
  List<Medicine> medicines;

  User(this.name, this.age, this.medicines);

  User.fromJson(Map<String, dynamic> json) {
    dynamic jsonResponse;

    name = json['name'];
    age = json['age'];
    jsonResponse = jsonDecode(json['medicines']);

    medicines =
        jsonResponse.map<Medicine>((jR) => Medicine.fromJson(jR)).toList();
  }

  Map<String, dynamic> toJson() =>
      {'name': name, 'age': age, 'medicines': jsonEncode(medicines)};

  @override
  String toString() {
    return ("User's name is $name, he/her age is $age and has ${medicines.length} medicines to take!");
  }

  User copyUser() => User(this.name, this.age, this.medicines);
}
