import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DropdownMenu extends StatefulWidget {
  TextEditingController controller;
  Size size;
  List<String> values;

  DropdownMenu({
    @required this.controller,
    @required this.size,
    @required this.values,
  });

  @override
  State<StatefulWidget> createState() => _DropdownMenuState();
}

class _DropdownMenuState extends State<DropdownMenu> {
  String dropdownValue;

  Widget buildDropdown() {
    Widget button = DropdownButton<String>(
      isExpanded: true,
      alignment: Alignment.centerLeft,
      icon: Icon(
        Icons.arrow_drop_down,
      ),
      items: widget.values.map((String dropValue) {
        return DropdownMenuItem<String>(
          value: dropValue,
          child: Text(dropValue),
        );
      }).toList(),
      value: dropdownValue,
      onChanged: (newValue) {
        setState(() {
          dropdownValue = newValue;
          widget.controller.text = dropdownValue;
        });
      },
    );

    return button;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size.width * 0.9,
      child: ButtonTheme(
        alignedDropdown: true,
        child: buildDropdown(),
      ),
    );
  }
}
