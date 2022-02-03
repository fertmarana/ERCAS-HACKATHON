import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100.0),
      child: Image.asset(
        'imagens/fotoperfil.png',
        fit: BoxFit.cover,
        height: 70,
        width: 70,
      ),
    );
  }
}
