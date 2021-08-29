import 'package:flutter/material.dart';
import 'package:recat/classes_definicao/ColetaAgendada.dart';
import 'dart:convert';
import 'package:recat/app_usuario_catadores/display_agendamentosCard_Swipe_catadores.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';
import 'package:flutter_tindercard/flutter_tindercard.dart';

// The Home Page of Scavengers would be a list of appointments they have for the current day

class CentralPage_catadores extends StatefulWidget {


  _CentralPage_catadores createState() => _CentralPage_catadores();
}

class _CentralPage_catadores extends State<CentralPage_catadores> {



//CentralPage({Key key}) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  


  Coletas parseJosn(String response) {
    if(response==null){
      return null;
    }
    Map<String, dynamic> jsonMap = json.decode(response);

    Coletas temp = Coletas.fromJson(jsonMap);
    return temp;

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,

      body:
      Container(
        alignment: Alignment(0.0, 0.7),
      child: Wrap(
        runSpacing: 2.0,
        direction: Axis.horizontal,
        children: [
          Container(
            alignment: Alignment(-0.7, 1),
            child: Text('Hoje ( 05/02/2021 )',
              style: TextStyle(
                  fontSize: 30.0,
                  color: Color(0xff16613D)
              ),
            ),
          ),
          Align(
          alignment:  Alignment(0.0, 1),
          child: Container(

                    // Use future builder and DefaultAssetBundle to load the local JSON file
                    child: new FutureBuilder(
                        future: //loadAgendamento(),
                        DefaultAssetBundle.of(context).loadString('assets/ColetasdoDia.json'),
                        builder: (context, snapshot) {
                          print(snapshot);

                          var data = parseJosn(snapshot.data.toString());

                          return AgendamentoLista_catadores(agenda: data);
                        }),
                  ),


              )
        ]

      ),
    )




    );
  }
}

class AgendamentoLista_catadores extends StatefulWidget {
  final Coletas agenda;
  AgendamentoLista_catadores({Key key, this.agenda}) : super(key: key);

  _AgendamentoLista_catadores createState() => _AgendamentoLista_catadores();
}

class _AgendamentoLista_catadores extends State<AgendamentoLista_catadores> {
  Coletas ascoletas_carregadas ;
  int len;
  List<String> statusColetaAtual = new List();
  List<MaterialColor> backgroundColor = new List();
  var controller = PageController(
    viewportFraction: 0.6,
    initialPage: 0,

  );

  @override
  void initState() {
    // TODO: implement initState
    ascoletas_carregadas = widget.agenda;
    len = widget.agenda.coletando.length;

    for (int i = 0; i < len; i++) {
      backgroundColor.add(Colors.grey);
      statusColetaAtual.add("agendada");
    }

    super.initState();
  }

  String transformListintoString(List<dynamic> lixo){
    String frasefinal = "";
    int i;
    for(i = 0; i < lixo.length -1 ;i++){
      frasefinal = frasefinal + lixo[i] + ", ";
    }
    frasefinal = frasefinal + lixo[i]+ ".";
    return frasefinal;
  }




  @override
  Widget build(BuildContext context) {

    return  Container(
       // margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
        height: 550.0,
        width: 380,
        child: ListView.builder(
            //controller: controller,
            scrollDirection: Axis.vertical,
            itemCount: ascoletas_carregadas == null ? 0 : len, // Can be null
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                      padding: EdgeInsets.only(top: 5, bottom: 5),
                      child: Container(
                          width: 200.0,
                          height: 300.0,
                          //margin: EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            //color: Color(0xffb714365),
                            color: Colors.white,

                            border: Border.all(
                              color: Colors.black,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Wrap(
                            children: [
                              Align(
                                  alignment: Alignment.topRight,
                                  child:
                                  Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Container(
                                            width: 100.0,
                                            height: 50.0,
                                            decoration: BoxDecoration(
                                              color: backgroundColor[index],
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 8,
                                              ),

                                              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                            ),

                                            child:  Text('Coleta ' + statusColetaAtual[index],
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 20.0, color: Colors.white),)

                                        )
                                      ]
                                  )
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    //decoration: BoxDecoration(border: Border.all(color: Colors.blue, width: 5)),
                                    child: Image.asset(
                                      'imagens/icone_localizacao.png',
                                      fit: BoxFit.cover,
                                      height: 50, // set your height
                                      width: 70, // and width here
                                    ),
                                  ),
                                  Text('Endereço: \n' + ascoletas_carregadas.coletando[index].enderecoColeta,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(fontSize: 17.0, color: Colors.black),)
                                ],
                              ),
                              Container(
                                  width: 500.0,
                                  height: 30.0,
                                  child:   Text('  Dia da Coleta: ' + ascoletas_carregadas.coletando[index].diaColeta,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 20.0, color: Colors.black),)
                              ),
                              Container(
                                  width: 500.0,
                                  height: 30.0,
                                  child:   Text('  Horário disponível: ' + ascoletas_carregadas.coletando[index].horaColeta,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 20.0, color: Colors.black),)
                              ),
                              Container(
                                  width: 500.0,
                                  height: 60.0,
                                child: Align(
                                    alignment: Alignment(-0.70,-0.8),
                                  child:   Text('  Tipo de Lixo: ' + transformListintoString(ascoletas_carregadas.coletando[index].tipoLixo.toList()),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 20.0, color: Colors.black),)
                                )
                              ),
                              Container(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Material(

                                      borderRadius: BorderRadius.circular(30.0),


                                      color: Color(0xFF009E74),
                                      child: MaterialButton(

                                        minWidth: 200.0,
                                        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                        onPressed: () {
                                          setState(() {
                                            backgroundColor[index] = Colors.green;
                                            statusColetaAtual[index] = "feita!";
                                          });
                                        },
                                        child: Text("Coletado",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 20.0,color: Colors.white, fontWeight: FontWeight.bold)),
                                      ),
                                    ),

                                  )
                              ),


                            ],
                          )
                      )

              );



              // );

            }

        )
    );
  }
}