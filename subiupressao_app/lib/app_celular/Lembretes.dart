import 'package:flutter/material.dart';

// Here the residents can check their data such as their waste collection history,
// their registered adresses and their statistics.

class Lembretes extends StatelessWidget {
  final String morador;

  Lembretes({Key key, this.morador}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 70, 10, 10),
      child: Wrap(
        runSpacing: 6.0,
        direction: Axis.horizontal,
        children: [
          SizedBox(height: 10.0),
          Container(
            alignment: Alignment(0.0, 0.6),
            child: Text(
              'Veja seus Lembretes, Astolfo ',
              style: TextStyle(fontSize: 28.0, color: Color(0xff16613D)),
            ),
          ),
          Container(
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              width: 500.0,
              height: 250.0,
              child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const <Widget>[
                    Card(
                      child: ListTile(
                        title: Text('Beba Água',
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(fontSize: 20.0, color: Colors.black)),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: Text('Caminhe 1 hora por dia',
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(fontSize: 20.0, color: Colors.black)),
                      ),
                    ),
                  ]))
        ],
      ),
    );
  }
}
