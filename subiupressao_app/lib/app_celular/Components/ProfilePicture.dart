import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return ClipRRect(
      borderRadius: BorderRadius.circular(100.0),
      child: Image.asset(
        'imagens/fotoperfil.png',
        fit: BoxFit.cover,
        height: size.height * 0.1,
        width: size.width * 0.2,
      ),
    );
  }
}
