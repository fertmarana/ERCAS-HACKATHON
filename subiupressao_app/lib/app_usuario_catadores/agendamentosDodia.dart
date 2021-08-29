import 'package:flutter/material.dart';
import 'package:recat/classes_definicao/ColetaAgendada.dart';
import 'dart:convert';
import 'package:recat/app_usuario_catadores/display_agendamentosCard_Swipe_catadores.dart';
import 'package:recat/CatadorouMorador.dart';

// This app show in a CardSwipe style the appointments scheduled but not yet confirmed by the scavengers
// In this screen the scavengers can choose to accept or refuse an appointment

class agendamentosDia_catadores extends StatefulWidget {


  _agendamentosDia_catadores createState() => _agendamentosDia_catadores();
}

class _agendamentosDia_catadores extends State<agendamentosDia_catadores> {


  var controller = PageController(
    viewportFraction: 1,
    initialPage: 0,
  );



  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Coletas parseJosn(String response) {
    if(response==null){
      return null;
    }
    Map<String, dynamic> jsonMap = json.decode(response);

    Coletas temp = Coletas.fromJson(jsonMap);
    return temp;

  }

  final agendarButon = Material(

    borderRadius: BorderRadius.circular(30.0),


    color: Color(0xFF009E74),
    child: MaterialButton(

      minWidth: 200.0,
      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
      onPressed: () {},
      child: Text("Agendar Coleta",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
              fontWeight: FontWeight.bold)),
    ),
  );

  // In the app there is ⚙️ icon that opens a drawer with the following buttons:
  // notifications, privacy, about the app, help and exit the app (they are not function).
  final drawer = Drawer(
    child: ListView(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.notifications_active),
          title: Text("Notificações"),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
          },
        ),
        ListTile(
          leading: Icon(Icons.lock),
          title: Text("Privacidade"),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
          },
        ),
        ListTile(
          leading: Icon(Icons.info),
          title: Text("Sobre"),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
          },
        ),
        ListTile(
          leading: Icon(Icons.help_center),
          title: Text("Ajuda"),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
          },
        ),
        ListTile(
          leading: Icon(Icons.sensor_door),

          title: Text("Sair"),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            builder: (_) => CatadorOuMorador();

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
            style: TextStyle(
                color: Color(0xff16613D), fontWeight: FontWeight.bold)
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
            child: Container(
              child: new Center(
                // Use future builder and DefaultAssetBundle to load the local JSON file
                child: new FutureBuilder(
                    future: //loadAgendamento(),
                    DefaultAssetBundle.of(context).loadString('assets/AgendamentosdoDia.json'),
                    builder: (context, snapshot) {
                      print(snapshot);

                      var data = parseJosn(snapshot.data.toString());
                      print(data);
                      //;
                      return data == null? Container(child: Text('oi'),):
                      //Container(child: Text('aqui'),);
                      Container(
                          width: 600,
                          height: 800,
                          child: display_CardSwipe(ascoletas: data)
                      );
                    }),
              ),
            )

        ),

      ),

    );
  }
}
