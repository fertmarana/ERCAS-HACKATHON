import 'package:flutter/material.dart';
import 'package:recat/app_usuarios_moradores/AgendamentoFeito.dart';
int howManySelected = 0;


class AgendarColeta_Pag2 extends StatefulWidget {

  @override
  _AgendarColeta_Pag2 createState() => _AgendarColeta_Pag2();
}

class _AgendarColeta_Pag2 extends State<AgendarColeta_Pag2> {
  DateTime pickedDate;
  TimeOfDay timeFirst;
  TimeOfDay timeSecond;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    pickedDate = DateTime.now();
    timeFirst = TimeOfDay.now();
    timeSecond = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context){
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
            //IconButton(icon: Icon(Icons.person_outline, color: Color(0xff16613D)),
            // onPressed: () {
            // Navigator.push(
            // context,
            // MaterialPageRoute(builder: (context) => editperfil()),
            //);},
            //),
          ],
        ),
      body: Align(
        alignment: Alignment(0.0,-1),
        child: Wrap(
          children: [
            Container(
              alignment: Alignment(-0.65,-0.9),
              child: Text('Dia e Hora da Coleta ' ,
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 20.0, color: Colors.green),)
              ,
            ),
            Align(
            alignment: Alignment(0.0,-1),
          child: Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                  width: 350.0,
                  height: 180.0,
                  decoration: BoxDecoration(color: Colors.white,
                    border: Border.all(
                      color: Colors.black,
                      width: 2,),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Align(
                    alignment: Alignment(0.0,0.0),
                    child: Wrap(
                        children: [
                                SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      ListTile(
                                        title: Text("Dia de Coleta: ${pickedDate.year}, ${pickedDate.month}, ${pickedDate.day}"),
                                        trailing: Icon(Icons.keyboard_arrow_down),
                                        onTap: _pickDate,
                                      ),
                                      Container(
                                        alignment: Alignment(-0.8,0),
                                        child: Text('A coleta pode ser feita ' ,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(fontSize: 15.0, color: Colors.black),)
                                        ,
                                      ),

                                      ListTile(
                                        title: Text("Das: ${timeFirst.hour}:${timeFirst.minute}"),
                                        trailing: Icon(Icons.keyboard_arrow_down),
                                        onTap: _pickTimeFirst,
                                      ),
                                      ListTile(
                                        title: Text("às: ${timeSecond.hour}:${timeSecond.minute}"),
                                        trailing: Icon(Icons.keyboard_arrow_down),
                                        onTap: _pickTimeSecond,
                                      ),
                                    ],
                                  ),
                                ),
                        ]
                      )
                  )

              )
            ),
            Container(
              alignment: Alignment(-0.65,-0.9),
              child: Text('Selecione uma Cooperativa/Catador' ,
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 20.0, color: Colors.green),)
              ,
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
                  child: SelectedCheckboxCooperativas(),
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
                        if(howManySelected == 1) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>
                                AgendamentoFeito()),
                          );
                        }
                      },
                      child: Text("Seguir",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20.0,color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),

                )
            ),
          ]
          )
        )

    );
  }


  _pickDate() async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year+5),
      initialDate: pickedDate,
      helpText: "Selecione Dia",
      cancelText: "Agora não",
      confirmText: "Selecionar",
      selectableDayPredicate: _decideWhichDayToEnable,
    );
    if(date != null)
      setState(() {
        pickedDate = date;
      });
  }
  _pickTimeFirst() async {

    TimeOfDay t = await showTimePicker(
        context: context,
        initialTime: timeFirst,
    );
    if(t != null)
      setState(() {
        timeFirst = t;
      });
  }

  _pickTimeSecond() async {

    TimeOfDay t = await showTimePicker(
      context: context,
      initialTime: timeFirst,
    );
    if(t != null)
      setState(() {
        timeSecond = t;
      });
  }



  bool _decideWhichDayToEnable(DateTime day) {
    if ((day.isAfter(DateTime.now().subtract(Duration(days: 1))) &&
        day.isBefore(DateTime.now().add(Duration(days: 10))))) {
      return true;
    }
    return false;
  }

}

class SelectedCheckboxCooperativas extends StatefulWidget {
  @override
  _SelectedCheckboxCooperativas createState() => new _SelectedCheckboxCooperativas();
}

class _SelectedCheckboxCooperativas extends State<SelectedCheckboxCooperativas> {
  //MultiSelectController controller = new MultiSelectController();
  List<Cooperativas> mainList = new List();

  @override
  void initState() {
    // TODO: implement initState
    mainList.add(Cooperativas(name : "Cooperativa Recicla", isSelected: false));
    //mainList.add(Cooperativas(name : "Cooperativa Lixo Reciclável", isSelected: false));
    mainList.add(Cooperativas(name : "João Barbosa", isSelected: false));

    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: mainList.length,
      itemBuilder: (context, index) {
        return ListTile(
            onTap: () {
          setState(() {
            if(!mainList[index].isSelected) {
              mainList[index].isSelected = true;
              howManySelected = 1;
            }
            else if(mainList[index].isSelected) {
              mainList[index].isSelected = false;
              howManySelected = 0;
            }
            mainList.forEach((element) {
              if ( element.name != mainList[index].name) {
                element.isSelected = false;
              }
            });
           //

           // log(paints[index].selected.toString());
          });
        },
        selected: mainList[index].isSelected,
        leading: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {},
          child: Container(
            width: 48,
            height: 48,
            padding: EdgeInsets.symmetric(vertical: 4.0),
            alignment: Alignment.center,
            )
          ),
          title: Text(mainList[index].name),
          trailing: (mainList[index].isSelected)
              ? Icon(Icons.check_box)
              : Icon(Icons.check_box_outline_blank),
        );
      },
    );
  }
}

class Cooperativas {
  String name;
  bool isSelected;

  Cooperativas({this.name, this.isSelected = false});
}


Iterable<TimeOfDay> getTimes(TimeOfDay startTime, TimeOfDay endTime, Duration step) sync* {
  var hour = startTime.hour;
  var minute = startTime.minute;

  do {
    yield TimeOfDay(hour: hour, minute: minute);
    minute += step.inMinutes;
    while (minute >= 60) {
      minute -= 60;
      hour++;
    }
  } while (hour < endTime.hour ||
      (hour == endTime.hour && minute <= endTime.minute));
}