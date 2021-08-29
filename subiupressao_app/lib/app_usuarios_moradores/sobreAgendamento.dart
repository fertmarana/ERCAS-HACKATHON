import 'package:flutter/material.dart';
import 'package:recat/app_usuarios_moradores/CentralPage.dart';
import 'dart:convert';

import 'package:recat/classes_definicao/ColetaAgendada.dart';

// This screen shows the information on a specific waste collection appoitment

class sobreAgendamento extends StatelessWidget {
 ColetaAgendada agendas;

  sobreAgendamento({Key key, this.agendas}) : super(key: key);

String concatenateString(List<dynamic> lista){
  var dlista = List<String>.from(lista);
  final string = dlista.reduce((value, element) => value + ',' + element);
  print(string);
  return string;
  }

  MaterialColor checkStatusColeta (String statusColeta) {
    if (statusColeta == 'agendada') {
      return Colors.blue;
    }
    else if (statusColeta == 'feita') {
      return Colors.green;
    }
    else return Colors.red;
  }


  final cancelarButon = Material(

    borderRadius: BorderRadius.circular(30.0),


    color: Colors.red,
    child: MaterialButton(

      minWidth: 200.0,
      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
      onPressed: () {},
      child: Text("Cancelar Coleta",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20.0,color: Colors.white, fontWeight: FontWeight.bold)),
    ),
  );
  final editarColetaButon = Material(

    borderRadius: BorderRadius.circular(30.0),


    color: Colors.lightBlue,
    child: MaterialButton(

      minWidth: 200.0,
      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
      onPressed: () {},
      child: Text("Editar Coleta",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20.0,color: Colors.white, fontWeight: FontWeight.bold)),
    ),
  );


 Widget _cancelarButton() {
   return agendas.statusColeta == "agendada"
       ? Container(
       padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
       width: 500.0,
       height: 50.0,
       child: cancelarButon)
       : Container();
 }
 Widget _editarButton() {
   return agendas.statusColeta == "agendada"
       ?
        Container(
       padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
       width: 500.0,
       height: 50.0,
       child: editarColetaButon)
       : Container();
 }


  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
        onLongPress : (){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CentralPage()),
      );
    },
    child: Padding(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: Container(

        alignment: Alignment.topCenter,
        margin: EdgeInsets.symmetric(vertical: 10.0),
          decoration: BoxDecoration(
            //color: Color(0xffb714365),
            color: Colors.white,

            border: Border.all(
              color: Colors.black,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
      height: 800.0,
      width: 800,
      child: Container(
           padding: const EdgeInsets.all(5.0),
          child: Wrap(

          runSpacing: 2.0,
          children: <Widget> [
            Align(
                alignment: Alignment.topRight,
                child:
                Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          width: 200.0,
                          height: 70.0,
                          decoration: BoxDecoration(
                            color: checkStatusColeta(agendas.statusColeta),
                            border: Border.all(
                              color: Colors.white,
                              width: 10,
                            ),

                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                          ),

                          child:  Text('Coleta ' + agendas.statusColeta,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 30.0, color: Colors.white),)

                      )
                    ]
                )
            ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Container(
                    padding: const EdgeInsets.all(10.0),
                    //decoration: BoxDecoration(border: Border.all(color: Colors.blue, width: 5)),
                    child: Image.asset(
                      'imagens/icon_lixo.png',
                      fit: BoxFit.cover,
                      height: 80, // set your height
                      width: 80, // and width here
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.fromLTRB(10, 40, 10, 0),
                    child:Text('Dia da Coleta: ' + agendas.diaColeta,

                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 20.0, color: Colors.black),)
                  ),

                ],
              ),
              Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  width: 500.0,
                  height: 50.0,
                  child:   Text('Endereço: ' + agendas.enderecoColeta,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 20.0, color: Colors.black),)
              ),
            Container(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                width: 500.0,
                height: 50.0,
                child:   Text('Horário: ' + agendas.horaColeta,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 20.0, color: Colors.black),)
            ),
              Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  width: 500.0,
                  height: 50.0,
                  child:   Text('Cooperativa: ' + agendas.cooperativa,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 20.0, color: Colors.black),)
              ),
            Container(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                width: 500.0,
                height: 50.0,
                child:   Text('Tipo de Lixo: ' + concatenateString(agendas.tipoLixo),
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 20.0, color: Colors.black),)
            ),
            _editarButton(),
            _cancelarButton(),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              width: 500.0,
              height: 50.0,
              child: Material(

                color: Colors.white,
                child: MaterialButton(

                  minWidth: 200.0,
                  padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CentralPage()),
                    );
                  },
                  child: Text("Voltar a Página Inicial",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20.0,color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              ),
            ),




        ]
       )
      )
     )
    )
    );
  }




}