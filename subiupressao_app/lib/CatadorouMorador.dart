import 'package:flutter/material.dart';
import 'package:recat/app_usuario_catadores/app_catadores.dart';
import 'package:recat/app_usuarios_moradores/app.dart';


class CatadorOuMorador extends StatelessWidget {
// This app is separated into 2 types: Scavenger and Residents
// Since this is a prototype yet, this screen helps the developers to choose
// with screen they want to see now
// This will not exist in the final product

  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          alignment: Alignment.bottomCenter,
          height: 600,
          child: Column(
          children: [
            SizedBox(height:150),
            Container(
              height: 200,
                  child: Material(
                      borderRadius: BorderRadius.circular(30.0),
                      color: Color(0xFF009E74),
                      child: MaterialButton(
                          minWidth: 200.0,
                          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          onPressed: () {
                            Navigator.push(context,

                              MaterialPageRoute(builder: (context) => App_catadores()),
                            );
                            },
                          child: Image.asset('imagens/imagem_catador.png',fit: BoxFit.cover)))
            ),
            SizedBox(height:10),
            Container(
                height: 200,
              child: Material(
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.green,
                  child: MaterialButton(

                      minWidth: 200.0,
                      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      onPressed: () {
                        Navigator.push(
                          context,

                          MaterialPageRoute(builder: (context) => App()),
                        );
                      },
                      child: Image.asset('imagens/imagem_catador.png',
                    fit: BoxFit.cover,)
                  ),
              )
            )

            ],
          )
        )
    );
  }



}