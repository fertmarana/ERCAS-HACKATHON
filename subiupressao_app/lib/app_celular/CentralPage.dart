import 'package:flutter/material.dart';
import 'package:subiupressao_app/bluetooth/Bluetooth_test.dart';
import 'package:subiupressao_app/classes_definicao/ColetaAgendada.dart';
import 'package:subiupressao_app/app_celular/PageView_Dados.dart';
import 'package:subiupressao_app/app_celular/Remedios/MedicinesList.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';
import 'package:subiupressao_app/bluetooth/Bluetooth_test.dart';
// Home Page for the Phone App
// A primeira parte contem os dados de pressão do paciente ao longo do tempo
// é tambem possivel ver em grafico ou em lista os dados dessa pressao
// Embaixo dos graficos, temos um app de lembrete para tomar os remedios de pressao

class CentralPage extends StatefulWidget {
_CentralPage createState() => _CentralPage();
}

class _CentralPage extends State<CentralPage>{

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }
// esse page controler é pra primeira parte do grafico.
// começa na minitela 0 e esse viewportFraction faz com que eu veja 100% dessa tela
// se eu colocar um valor entre 0 e 1, conseguirei ver parte das outras telas.
var controller = PageController(
  viewportFraction: 1 ,
  initialPage: 0,
);


// #####################################################
// Isso é do codigo antigo, mas achei legal deixar só para caso usemos no futuro
// o que ele faz é ler um arquivo .json e decodificá-lo
// enquanto não temos um sql para os dados podemos tentar usar esse json para ler dados
// uma coisa que descobri é q esse json só consegue ler do arquivo e não escrever nele
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Coletas parseJosn(String response) {
    if(response==null){
      return null;
    }
    Map<String, dynamic> jsonMap = json.decode(response);

    Coletas temp = Coletas.fromJson(jsonMap);
    return temp;

  }
// #####################################################


// In the app there is ⚙️ icon that opens a drawer with the following buttons:
// notifications, privacy, about the app, help and exit the app (they are not function).
final drawer = Drawer(
  child: ListView(
    children: <Widget>[
      ListTile(
        leading: Icon(Icons.notifications_active),
        title: Text("Notificações"),
        trailing: Icon(Icons.arrow_forward),
        onTap: (){
        },
      ),
      ListTile(
        leading: Icon(Icons.lock),
        title: Text("Privacidade"),
        trailing: Icon(Icons.arrow_forward),
        onTap: (){
        },
      ),
      ListTile(
        leading: Icon(Icons.info),
        title: Text("Sobre"),
        trailing: Icon(Icons.arrow_forward),
        onTap: (){
        },
      ),
      ListTile(
        leading: Icon(Icons.help_center ),
        title: Text("Ajuda"),
        trailing: Icon(Icons.arrow_forward),
        onTap: (){
        },
      ),
      ListTile(
        leading: Icon(Icons.sensor_door),

        title: Text("Sair"),
        trailing: Icon(Icons.arrow_forward),
        onTap: (){
         // builder: (_) =>;
        },
      ),
    ],
  ),
);



@override
Widget build(BuildContext context) {
  return Scaffold(
    key: _scaffoldKey,
    endDrawer: drawer,
    appBar: AppBar(
      title: const Text('',
          style: TextStyle(color: Color(0xff16613D), fontWeight: FontWeight.bold)
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      actions: <Widget>[
        IconButton(icon: Icon(Icons.settings, color: Color(0xff16613D)),
          onPressed: () => _scaffoldKey.currentState.openEndDrawer(),
        ),
      ],
    ),

    body:  Container(
      child: Align(
      alignment: Alignment.topCenter,
      child: Wrap(
        runSpacing: 6.0,
        direction: Axis.horizontal,
        children: [
          Container(
            alignment: Alignment(0.0, 0.6),
            child: Text('Bem vindo, Astolfo',
              style: TextStyle(
                  fontSize: 30.0,
                  color: Color(0xff16613D)
              ),
            ),
          ),
          SizedBox(height: 10.0),
          // Nesse PageView_Dados está em outra tela para deixar o codigo
          // um pouco mais organizado
          PageView_Dados(),
          //Bluetooth_testing(),
          SizedBox(height: 20.0),
          /*
          Outra parte do codigo antigo que eu só quis deixar para mostrar
          como podemos chamar uma outra pagina de outro arquivo

          Codigo deletado:
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
                      Navigator.push(
                        context,

                        MaterialPageRoute(builder: (context) => AgendarColeta_Pag1()),
                      );
                    },
                    child: Text("Agendar Coleta",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20.0,color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),

              )
          ),

          Outra parte do codigo deletada, mas que quis deixar para mostrar como
          podemos ler um codigo json que criarmos

          Container(
            child: new Center(
              child: Text('Oi'),
            ),
          )*/
          /*Container(
            child: new Center(
              child: new FutureBuilder(
                  future: //loadAgendamento(),
                  DefaultAssetBundle.of(context).loadString('assets/Agendamento.json'),
                  builder: (context, snapshot) {
                    print(snapshot);

                    var data = parseJosn(snapshot.data.toString());

                    return AgendamentoLista(agenda: data);
                  }),
            ),
          )*/
        ],
      ),
    ),
    ),
  );
}
}

