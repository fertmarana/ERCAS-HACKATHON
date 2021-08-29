import 'package:flutter/material.dart';
import 'package:recat/classes_definicao/ColetaAgendada.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';

class display_CardSwipe extends StatefulWidget {
  final Coletas ascoletas ;
  display_CardSwipe({Key key, this.ascoletas}) : super(key: key);
  _display_CardSwipe createState() => _display_CardSwipe();
}

class _display_CardSwipe extends State<display_CardSwipe> {
  int len;
  List<Widget> cardList;
  List<String> statusPedidoAtual = new List();
  List<MaterialColor> backgroundColor = new List();
  Coletas ascoletas_carregadas ;
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;

  void _removeCard(index) {
    setState(() {
      cardList.removeAt(index);
      len = len - 1;
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    ascoletas_carregadas = widget.ascoletas;
    len = widget.ascoletas.coletando.length;
    for(int i = 0; i<len; i++){
      backgroundColor.add( Colors.grey);
      statusPedidoAtual.add("em espera");
    }
   // print(agenda_coletas);


    super.initState();
  }


  MaterialColor checkStatusPedido (String statusPedido) {
    if (statusPedido == 'em espera') {
      return Colors.grey;
    }
    else if (statusPedido == 'aprovado') {
      return Colors.green;
    }
    else return Colors.red;
  }





  Widget build(BuildContext context) {
    CardController controller;

    return Scaffold(
      body: Container(
       child: Align(
        alignment: Alignment.topCenter,
        child: new TinderSwapCard(
         orientation: AmassOrientation.BOTTOM,
         totalNum: ascoletas_carregadas.coletando.length,
         stackNum: 3,
         swipeEdge: 4.0,
         maxWidth: MediaQuery.of(context).size.width * 1.1,
         maxHeight: MediaQuery.of(context).size.width * 1.1,
         minWidth: MediaQuery.of(context).size.width * 0.8,
         minHeight: MediaQuery.of(context).size.width * 0.8,
         cardBuilder: (context, index) {
           print('index ${index}');
           return Card(
             child: Container(
               color: Colors.white,
               alignment: Alignment(-0.9,0.0),

               child: Card(
                 elevation: 12,
                 color: Colors.white,
                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                 child: Container( width: 400, height: 700,
                   child:  Wrap(
                     children: [
                       Align(
                           alignment: Alignment.topRight,
                           child: Column(
                               crossAxisAlignment: CrossAxisAlignment.stretch,
                               children: [
                                 Container(
                                     width: 100.0,
                                     height: 50.0,
                                     decoration: BoxDecoration(
                                       color: backgroundColor[index],
                                       border: Border.all(color: Colors.white, width: 8,),
                                       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                     ),

                                     child:  Text('Pedido ' + statusPedidoAtual[index],
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
                             child: Image.asset('imagens/icone_localizacao.png',
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
                           height: 60.0,
                           child:   Text('  Pode ser coletado: ' + ascoletas_carregadas.coletando[index].horaColeta,
                             textAlign: TextAlign.left,
                             style: TextStyle(fontSize: 20.0, color: Colors.black),)
                       ),
                       Container(
                           width: 500.0,
                           height: 60.0,
                           child:   Text('  Pedido por: ' + ascoletas_carregadas.coletando[index].moradorNome,
                             textAlign: TextAlign.left,
                             style: TextStyle(fontSize: 20.0, color: Colors.black),)
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
                                     statusPedidoAtual[index] = "aceito!";
                                   });
                                 },
                                 child: Text("Aceitar Pedido",
                                     textAlign: TextAlign.center,
                                     style: TextStyle(
                                         fontSize: 20.0,color: Colors.white, fontWeight: FontWeight.bold)),
                               ),
                             ),

                           )
                       ),
                       Container(
                           child: Align(
                             alignment: Alignment.center,
                             child: Material(

                               borderRadius: BorderRadius.circular(30.0),


                               color: Colors.red,
                               child: MaterialButton(

                                 minWidth: 200.0,
                                 padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                 onPressed: () {
                                   setState(() {
                                     backgroundColor[index] = Colors.red;
                                     statusPedidoAtual[index] = "recusado!";
                                   });
                                 },
                                 child: Text("Recusar Pedido",
                                     textAlign: TextAlign.center,
                                     style: TextStyle(
                                         fontSize: 20.0,color: Colors.white, fontWeight: FontWeight.bold)),
                               ),
                             ),

                           )
                       ),


                     ],
                   ),
                 ),
               )
             )

           );
         },
         cardController: controller = CardController(),
         swipeUpdateCallback: (DragUpdateDetails details, Alignment align) {
           /// Get swiping card's alignment
           if (align.x < 0) {
             //print("Card is LEFT swiping");
           } else if (align.x > 0) {
             //print("Card is RIGHT swiping");
           }
         },
         swipeCompleteCallback:
             (CardSwipeOrientation orientation, int index) {
           print(orientation.toString());
           if (orientation == CardSwipeOrientation.LEFT) {
             print("Card is LEFT swiping");
             print(ascoletas_carregadas.coletando.length);
           } else if (orientation == CardSwipeOrientation.RIGHT) {
             print("Card is RIGHT swiping");
             print(ascoletas_carregadas.coletando.length);
           }
         },
       ),
      )
      )
    );
  }




}

