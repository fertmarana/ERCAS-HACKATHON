import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:subiupressao_app/app_celular/Components/UserDataInput.dart';
import 'package:subiupressao_app/app_celular/Components/Controller.dart';
import 'package:subiupressao_app/files/FileController.dart';
import 'package:subiupressao_app/files/models/medicine.dart';
import 'package:subiupressao_app/files/models/user.dart';
import 'package:table_calendar/table_calendar.dart';

class EditMedicine extends StatefulWidget {
  final Controller controller;
  final bool deleteButton;
  final Medicine element;

  EditMedicine({
    @required this.controller,
    this.deleteButton = false,
    this.element,
  });

  @override
  State<EditMedicine> createState() => _EditMedicineState();
}

class _EditMedicineState extends State<EditMedicine> {
  TextEditingController _medicineNameController;
  TextEditingController _pillsController;
  Map<String, Duration> intervals = {
    "3 dias": Duration(days: 2),
    "5 dias": Duration(days: 4),
    "1 semana": Duration(days: 6),
    "2 semanas": Duration(days: 13),
    "3 semanas": Duration(days: 20),
    "4 semanas": Duration(days: 27),
    "Sem tempo definido": Duration(seconds: 0),
  };
  String durationValue;
  DateTime dateTime;

  @override
  void initState() {
    _pillsController = TextEditingController(
      text: widget.element == null ? "" : widget.element.quantity.toString(),
    );

    _medicineNameController = TextEditingController(
      text: widget.element == null ? "" : widget.element.name,
    );

    dateTime = widget.element == null
        ? widget.controller.dateTime
        : widget.element.start;
  }

  @override
  Widget build(BuildContext context) {
    User _user = widget.controller.user.copyUser();
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: buildColumn(
            user: _user,
            size: size,
          ),
        ),
      ),
    );
  }

  Widget buildHead({User user}) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.close),
        ),
        Spacer(),
        Text(
          widget.element == null ? "Novo Remédio" : "Editar Remédio",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Spacer(),
        IconButton(
          onPressed: () {
            int index = user.medicines.length;

            if (widget.element != null) {
              index = user.medicines.indexOf(widget.element);
              user.medicines.remove(widget.element);
            }

            user.medicines.insert(
              index,
              Medicine(
                name: _medicineNameController.text,
                quantity: int.parse(_pillsController.text),
                start: dateTime,
                end: intervals[durationValue] == Duration(seconds: 0)
                    ? DateTime(2200)
                    : dateTime.add(intervals[durationValue]),
              ),
            );

            widget.controller.updateUser(newUser: user);

            Navigator.of(context).pop();
          },
          icon: Icon(Icons.check),
        ),
      ],
    );
  }

  Widget buildDropdown({Size size}) {
    return Container(
      width: size.width * 0.9,
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButton<String>(
          isExpanded: true,
          alignment: Alignment.centerLeft,
          icon: Icon(
            Icons.arrow_drop_down,
          ),
          items: intervals.keys.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          value: durationValue,
          onChanged: (newValue) {
            setState(() {
              durationValue = newValue;
            });
          },
        ),
      ),
    );
  }

  List<Widget> buildColumn({User user, Size size}) {
    var horizontalOffset = 0.05;

    List<Widget> column = [
      SizedBox(height: size.height * 0.05),
      // Head (Cancel button, title and save button)
      buildHead(user: user),
      SizedBox(height: size.height * 0.01),
      Icon(Icons.medication, size: 70),
      SizedBox(height: size.height * 0.03),
      UserDataInput(
        controller: _medicineNameController,
        fieldName: "Nome do remédio",
        hintString: "Nome do Remédio",
        spacerInterval: horizontalOffset,
      ),
      SizedBox(height: size.height * 0.03),
      UserDataInput(
        controller: _pillsController,
        keyboard: TextInputType.number,
        filter: [FilteringTextInputFormatter.digitsOnly],
        fieldName: "São quantos comprimidos por dia?",
        hintString: "Comprimidos por dia",
        spacerInterval: horizontalOffset,
      ),
      SizedBox(height: size.height * 0.03),
      Row(
        children: [
          SizedBox(width: horizontalOffset * size.width),
          Text(
            "Quando deve começar a ser tomado?",
            style: TextStyle(fontSize: 16),
          ),
          Spacer()
        ],
      ),
      Row(
        children: [
          SizedBox(width: size.width * horizontalOffset),
          TextField(
            enabled: false,
            decoration: InputDecoration(
              constraints: BoxConstraints(maxWidth: size.width * 0.75),
              border: OutlineInputBorder(),
              hintText: DateFormat("dd/MM/yyyy").format(dateTime),
            ),
          ),
          Spacer(),
          IconButton(
            onPressed: () {
              showDatePicker(
                      context: context,
                      initialDate: dateTime,
                      firstDate: DateTime(2010),
                      lastDate: DateTime(2200))
                  .then((date) {
                setState(() {
                  dateTime = (date == null ? dateTime : date);
                });
              });
            },
            icon: const Icon(
              Icons.calendar_today_rounded,
              size: 25,
            ),
            iconSize: size.width * 0.05,
          ),
          SizedBox(width: size.width * horizontalOffset),
        ],
      ),
      SizedBox(height: 20),
      Row(
        children: [
          SizedBox(width: size.width * horizontalOffset),
          Text("Até quando o remédio deve ser tomado?",
              style: TextStyle(fontSize: 16)),
          Spacer(),
        ],
      ),
      buildDropdown(size: size),
    ];

    if (widget.deleteButton == true) {
      column.add(ElevatedButton(
        onPressed: () {
          user.medicines.remove(widget.element);
          setState(() {
            widget.controller.updateUser(newUser: user);
          });
          Navigator.of(context).pop();
        },
        child: Text("Deletar remédio"),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            Color.fromARGB(255, 190, 40, 30),
          ),
        ),
      ));
    }

    return column;
  }
}
