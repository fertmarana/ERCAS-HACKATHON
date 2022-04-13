import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:subiupressao_app/app_celular/Components/Controller.dart';
import 'package:subiupressao_app/files/models/user.dart';

class InfoField extends StatefulWidget {
  Controller controller;
  String field;
  String data;

  InfoField({this.controller, this.field, this.data});

  @override
  State<StatefulWidget> createState() => _InfoFieldState();
}

class _InfoFieldState extends State<InfoField> {
  User _user;

  @override
  void initState() {
    _user = widget.controller.user;

    widget.controller.addListener(() {
      setState(() {
        _user = widget.controller.user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Card(
      margin: EdgeInsets.fromLTRB(
        size.width * 0.001,
        size.height * 0.002,
        size.width * 0.001,
        size.height * 0.002,
      ),
      color: Color(0xffd3d3d3),
      shape: BeveledRectangleBorder(),
      elevation: 2.5,
      child: Column(
        children: [
          SizedBox(height: size.height * 0.015),
          Row(
            children: [
              SizedBox(
                width: size.width * 0.02,
              ),
              Text(
                "${widget.field}:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: size.width * 0.02,
              ),
              Text("${widget.data}",
                  style: TextStyle(
                    fontSize: 16,
                  )),
            ],
          ),
          SizedBox(
            height: size.height * 0.015,
          ),
        ],
      ),
    );
  }
}
