import 'package:flutter/material.dart';
import 'package:subiupressao_app/app_celular/Components/ProfilePicture.dart';

class ProfileSummary extends StatelessWidget {
  List<Widget> children;

  ProfileSummary({@required this.children});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Positioned(
          child: Image.asset(
            'imagens/CardBackground.png',
            height: size.height * 0.1,
            width: size.width * 2,
          ),
          bottom: 0,
          left: size.width * -0.80,
        ),
        Card(
          margin: EdgeInsets.fromLTRB(
            size.width * 0.03,
            size.width * 0.03,
            size.width * 0.03,
            size.width * 0.03,
          ),
          elevation: 5,
          color: const Color(0xff00ffe0),
          child: Row(
            children: [
              SizedBox(width: size.width * 0.04),
              Column(
                children: [
                  SizedBox(height: size.height * 0.02),
                  ProfilePicture(),
                  SizedBox(height: size.height * 0.02),
                ],
              ),
              SizedBox(width: size.width * 0.06),
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
