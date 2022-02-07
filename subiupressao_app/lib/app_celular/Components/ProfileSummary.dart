import 'package:flutter/material.dart';
import 'package:subiupressao_app/app_celular/Components/ProfilePicture.dart';

class ProfileSummary extends StatelessWidget {
  List<Widget> children;

  ProfileSummary({@required this.children});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          child: Image.asset(
            'imagens/CardBackground.png',
            height: 110,
          ),
          bottom: 0,
          left: 20,
        ),
        Card(
          margin: EdgeInsets.fromLTRB(20, 15, 20, 15),
          elevation: 5,
          color: const Color(0xff00ffe0),
          child: Row(
            children: [
              SizedBox(width: 15),
              Column(
                children: [
                  SizedBox(height: 15),
                  ProfilePicture(),
                  SizedBox(height: 15),
                ],
              ),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              )
            ],
          ),
        ),
      ],
    );
  }
}
