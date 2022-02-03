class Medicine {
  String name;
  int quantity;
  DateTime start;
  DateTime end;

  Medicine({this.name, this.quantity, this.start, this.end});

  Medicine.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        quantity = json['quantity'],
        start = DateTime.parse(json['start']),
        end = DateTime.parse(json['end']);

  Map<String, dynamic> toJson() => {
        'name': name,
        'quantity': quantity,
        'start': start.toString(),
        'end': end.toString(),
      };
}
