import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserDataInput extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboard;
  final List<TextInputFormatter> filter;
  final String fieldName;
  final String hintString;
  final double spacerInterval;
  final bool enabled;

  const UserDataInput({
    Key key,
    this.controller,
    this.keyboard = TextInputType.text,
    this.filter = const [],
    this.fieldName,
    this.hintString,
    this.enabled = true,
    this.spacerInterval = 0.05,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double inputSize = 1 - spacerInterval * 2;
    Size size = MediaQuery.of(context).size;

    return Column(children: [
      Row(
        children: [
          SizedBox(width: spacerInterval * size.width),
          Text(fieldName, style: TextStyle(fontSize: 16)),
          Spacer()
        ],
      ),
      TextField(
        controller: this.controller,
        enabled: this.enabled,
        keyboardType: this.keyboard,
        inputFormatters: this.filter,
        decoration: InputDecoration(
          constraints: BoxConstraints(
              maxWidth: size.width * inputSize, minWidth: size.width * inputSize),
          border: OutlineInputBorder(),
          hintText: this.hintString,
          suffixIcon: IconButton(
            onPressed: () {
              this.controller.clear();
            },
            icon: const Icon(Icons.clear),
          ),
        ),
      ),
    ]);
  }
}
