class Appointment {
  String doctor;
  String speciality;
  DateTime date;

  Appointment({this.doctor, this.speciality, this.date});

  Appointment.fromJson(Map<String, dynamic> json)
      : doctor = json['doctor'],
        speciality = json['speciality'],
        date = DateTime.parse(json['date']);

  Map<String, dynamic> toJson() => {
        'doctor': doctor,
        'speciality': speciality,
        'date': date.toString(),
      };
}
