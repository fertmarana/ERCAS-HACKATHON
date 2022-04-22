import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:subiupressao_app/app_celular/Components/DropdownMenu.dart';

class UserDataDropdown extends StatefulWidget {
  final TextEditingController controller;
  final List<String> values;
  final String fieldName;
  final double spacerInterval;

  UserDataDropdown({
    this.controller,
    this.values,
    this.fieldName,
    this.spacerInterval = 0.05,
  });

  @override
  State<UserDataDropdown> createState() => _UserDataDropdownState();
}

class _UserDataDropdownState extends State<UserDataDropdown> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(children: [
      Row(
        children: [
          SizedBox(width: size.width * this.widget.spacerInterval),
          Text(widget.fieldName, style: TextStyle(fontSize: 16)),
        ],
      ),
      DropdownMenu(
        size: size,
        values: widget.values,
        controller: widget.controller,
      ),
      SizedBox(
        height: size.height * 0.01,
      )
    ]);
  }
}
