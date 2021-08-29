import 'package:flutter/material.dart';
import 'package:recat/app_usuarios_moradores/CentralPage.dart';
import 'dart:convert';

import 'package:recat/classes_definicao/ColetaAgendada.dart';

// Confirmation Page to show the Resident Users that the Collect was schedule
class AgendamentoFeito extends StatelessWidget {
  ColetaAgendada agendas;

  AgendamentoFeito({Key key, this.agendas}) : super(key: key);

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
                child: Align(
                    alignment: Alignment(0.0,0.0),
                    child:Container(
                    padding: const EdgeInsets.all(5.0),
                    child: Wrap(

                        runSpacing: 2.0,
                        children: <Widget> [
                          Align(
                          alignment: Alignment(0.0,0.0),
                            child: Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 120.0,
                            ),
                          ),
                          SizedBox(height: 120,),
                          Container(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              width: 500.0,
                              height: 50.0,
                              child:   Text('Pedido feito! \n'
                                  ,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 40.0, color: Colors.black),)
                          ),
                          SizedBox(height: 100,),
                          Container(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              width: 500.0,
                              height: 50.0,
                              child:   Text(
                                  'Enviamos uma notificação ao catador avisando sobre seu pedido!',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 20.0, color: Colors.black),)
                          ),
                          SizedBox(height: 100,),

                          Container(
                              decoration: BoxDecoration(
                                //color: Color(0xffb714365),
                                color: Colors.white,

                                border: Border.all(
                                  color: Colors.black,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),

                              child: Align(
                                alignment: Alignment(0.0,0.9),
                                child: Material(

                                  borderRadius: BorderRadius.circular(30.0),


                                  color: Colors.white,
                                  child: MaterialButton(


                                    minWidth: 200.0,
                                    padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                    onPressed: () {

                                       // Navigator.push(
                                       //   context,
                                         // MaterialPageRoute(builder: (context) =>AgendarColeta_Pag2()),
                                      //  );

                                    },
                                    child: Text("Quer tirar uma dúvida com o catador?",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 20.0,color: Colors.black)),
                                  ),
                                ),

                              )
                          ),
                          Container(
                              child: Align(
                                alignment: Alignment.center,
                                child: Material(
                                  borderRadius: BorderRadius.circular(30.0),


                                  color: Colors.white,
                                  child: MaterialButton(

                                    minWidth: 200.0,
                                    padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                    onPressed: () {
                                       Navigator.push(
                                        context,
                                       MaterialPageRoute(builder: (context) =>CentralPage()),
                                       );
                                    },
                                    child: Text("Voltar ao Menu Principal",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 20.0,color: Colors.black)),
                                  ),
                                ),

                              )
                          ),




                        ]
                    )
                    )
                )
            )
        )
    );
  }

}