import 'package:flutter/material.dart';

// Here the residents can check their data such as their waste collection history,
// their registered adresses and their statistics.

class MinhaContaMorador extends StatelessWidget {
  final String morador;
  MinhaContaMorador({Key key, this.morador}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.symmetric(vertical: 10.0),
            height: 800.0,
            width: 800,
            child: Container(
                padding: const EdgeInsets.all(5.0),
                child: Wrap(runSpacing: 20.0, children: [
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: Image.asset(
                        'imagens/fotoperfil.png',
                        fit: BoxFit.cover,
                        height: 200, // set your height
                        width: 200, // and width here
                      ),
                    ),
                  ),
                  Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.black,
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Astolfo',
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 30.0, color: Colors.black),
                      )),
                  Container(
                      alignment: Alignment.topCenter,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.black,
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      width: 500.0,
                      height: 250.0,
                      child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: const <Widget>[
                            Card(
                              child: ListTile(
                                title: Text('Meus Dados',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20.0, color: Colors.black)),
                              ),
                            ),
                            Card(
                              child: ListTile(
                                title: Text('Configurações',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20.0, color: Colors.black)),
                              ),
                            ),
                            Card(
                              child: ListTile(
                                title: Text('Sair',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20.0, color: Colors.black)),
                              ),
                            ),
                          ]))
                ]))));
  }
}
