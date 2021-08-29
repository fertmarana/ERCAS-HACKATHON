import 'package:flutter/material.dart';
import 'package:recat/classes_definicao/ColetaAgendada.dart';
import 'dart:convert';
import 'package:recat/app_usuarios_moradores/AgendarColeta_Pag2.dart';
import 'package:multi_select_item/multi_select_item.dart';



class AgendarColeta_Pag1 extends StatefulWidget {
  _AgendarColeta_Pag1 createState() => _AgendarColeta_Pag1();
}

class _AgendarColeta_Pag1 extends State<AgendarColeta_Pag1> {


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
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.keyboard_backspace_outlined, color: Color(0xff16613D)),
                onPressed: () { Scaffold.of(context).openDrawer(); },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          title: const Text('',
              style: TextStyle(color: Color(0xff16613D), fontWeight: FontWeight.bold)
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: <Widget>[
          ],
        ),


      body:  Container(
          child: Align(
          alignment: Alignment(0.0,-1),
          child: Wrap(
              runSpacing: 8.0,
              direction: Axis.horizontal,
              children: [
                SizedBox(height: 30.0),
                Container(
                  child: new Center(
                    // Use future builder and DefaultAssetBundle to load the local JSON file
                    child: new FutureBuilder(
                        future:
                        DefaultAssetBundle.of(context).loadString('assets/Agendamento.json'),
                        builder: (context, snapshot) {
                          print(snapshot);

                          Coletas data = parseJosn(snapshot.data.toString());

                          return ContainerEndereco(agenda: data);
                        }),
                  ),
                ),
                Container(
                  alignment: Alignment(-0.7, 0.6),
                  child: Text('Meu Lixo inclui: ',
                    style: TextStyle(
                        fontSize: 22.0,
                        color: Color(0xff16613D)
                    ),
                  ),
                ),
                Align(
                    alignment: Alignment(0.0,-1),
                    child: Container(
                      alignment: Alignment(0.5, 0.6),
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      width: 350.0,
                      height: 200.0,
                    //margin: EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(color: Colors.white,
                        border: Border.all( color: Colors.black,  width: 2,),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    child: SelectedCheckbox(),
                    )
                ),
                Container(
                    child: Align(
                      alignment: Alignment(0.75,0.0),
                      child: Material(

                        borderRadius: BorderRadius.circular(30.0),


                        color: Color(0xFF009E74),
                        child: MaterialButton(

                          minWidth: 200.0,
                          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AgendarColeta_Pag2()),
                            );
                          },
                          child: Text("Seguir",
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
      )
    );
  }
}



class ContainerEndereco extends StatelessWidget {
  final Coletas agenda;

  ContainerEndereco({Key key, this.agenda}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return new  Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                width: 350.0,
                height: 180.0,
                //margin: EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(color: Colors.white,
                  border: Border.all(
                    color: Colors.black,
                    width: 2,),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Align(
                    alignment: Alignment(0.0,0.5),
                    child: Wrap(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Image.asset('imagens/icone_localizacao.png',
                              fit: BoxFit.cover,
                              height: 70, // set your height
                              width: 70, // and width here
                            ),
                          ),
                          Text('Endereço: \n' + agenda.coletando[0].enderecoColeta,
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize: 20.0, color: Colors.black),)
                        ],
                      ),
                      Container(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Material(
                              borderRadius: BorderRadius.circular(30.0),


                              color: Colors.white,
                              child: MaterialButton(

                                minWidth: 200.0,
                                padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                onPressed: () {},
                                child: Text("Alterar",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        fontSize: 20.0,color: Colors.black, fontWeight: FontWeight.bold)),
                              ),
                            ),

                          )
                      ),


                  ],

                )
            )




    );
  }
}

class SelectedCheckbox extends StatefulWidget {
  @override
  _SelectedCheckbox createState() => new _SelectedCheckbox();
}

class _SelectedCheckbox extends State<SelectedCheckbox> {
  MultiSelectController controller = new MultiSelectController();
  List mainList = new List();

  @override
  void initState() {
    // TODO: implement initState
    mainList.add({"key": "Plástico"});
    mainList.add({"key": "Papel"});
    mainList.add({"key": "Eletrônicos"});
    mainList.add({"key": "Vidro"});
    mainList.add({"key": "Metal"});
    controller.set(mainList.length);
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: mainList.length,
      itemBuilder: (context, index) {
        return MultiSelectItem(
          isSelecting: controller.isSelecting,

          //the function that will be called when item is long-tapped/tapped
          onSelected: () {
            setState(() {
              controller.toggle(index);
            });
          },
          child: Container(
            child: ListTile(
              title: new Text(mainList[index]['key']),
            ),

            //change color based on wether the id is selected or not.
            decoration: controller.isSelected(index)
                ? new BoxDecoration(color: Color(0xFFC5F6E9))
                : new BoxDecoration(),
          ),
        );
      },
    );
  }
}

