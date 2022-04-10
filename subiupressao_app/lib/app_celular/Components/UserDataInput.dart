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
  final double maxWidth;

  const UserDataInput({
    Key key,
    this.controller,
    this.keyboard = TextInputType.text,
    this.filter = const [],
    this.fieldName,
    this.hintString,
    this.enabled = true,
    this.spacerInterval = 0.05,
    this.maxWidth = 0.9,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(children: [
      Row(
        children: [
          SizedBox(width: size.width * this.maxWidth * this.spacerInterval),
          Text(fieldName, style: TextStyle(fontSize: 16)),
        ],
      ),
      TextField(
        controller: this.controller,
        textCapitalization: TextCapitalization.sentences,
        enabled: this.enabled,
        keyboardType: this.keyboard,
        inputFormatters: this.filter,
        decoration: InputDecoration(
          constraints: BoxConstraints(maxWidth: size.width * this.maxWidth),
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
      SizedBox(
        height: size.height * spacerInterval / 2,
      )
    ]);
  }
}
