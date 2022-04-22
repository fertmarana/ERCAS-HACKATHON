import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class UserDateInput extends StatefulWidget {
  TextEditingController controller;
  DateTime dateTime;
  String fieldName;
  double horizontalOffset;

  UserDateInput({
    @required this.controller,
    @required this.dateTime,
    @required this.fieldName,
    this.horizontalOffset = 0.05,
  });

  @override
  State<StatefulWidget> createState() => _UserDateInputState();
}

class _UserDateInputState extends State<UserDateInput> {
  @override
  void initState() {
    print(widget.dateTime.toString());
    widget.controller.text = DateFormat("dd/MM/yyyy").format(widget.dateTime);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      children: [
        Row(
          children: [
            SizedBox(width: size.width * this.widget.horizontalOffset),
            Text(widget.fieldName, style: TextStyle(fontSize: 16)),
          ],
        ),
        Row(
          children: [
            SizedBox(width: size.width * widget.horizontalOffset),
            TextField(
              enabled: false,
              controller: widget.controller,
              decoration: InputDecoration(
                constraints: BoxConstraints(maxWidth: size.width * 0.7),
                border: OutlineInputBorder(),
              ),
            ),
            Spacer(),
            IconButton(
              onPressed: () {
                showDatePicker(
                  context: context,
                  initialDate: widget.dateTime,
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2200),
                ).then((date) {
                  setState(() {
                    widget.dateTime = (date == null ? widget.dateTime : date);
                    widget.controller.text =
                        DateFormat("dd/MM/yyyy").format(widget.dateTime);
                  });
                });
              },
              icon: const Icon(
                Icons.calendar_today_rounded,
                size: 25,
              ),
              iconSize: size.width * 0.025,
            ),
            SizedBox(width: size.width * widget.horizontalOffset),
          ],
        ),
        SizedBox(height: size.height * 0.01),
      ],
    );
  }
}
