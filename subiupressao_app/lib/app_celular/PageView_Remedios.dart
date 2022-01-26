import 'package:flutter/material.dart';
import 'dart:async';

class PageView_Remedios extends StatefulWidget {
  @override
  _PageView_Remedios createState() => _PageView_Remedios();
}

class _PageView_Remedios extends State<PageView_Remedios> {
  int _currentPage = 0;
  var controller = PageController(
    viewportFraction: .8 ,
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(vertical: 10.0),
      height: 200.0,
      width: 400,
      child: PageView(
        controller: controller,
        scrollDirection: Axis.horizontal,
        children: [
          Container(
              width: 200.0,
              height: 200.0,

              margin: EdgeInsets.symmetric(horizontal: 10.0),
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
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          //decoration: BoxDecoration(border: Border.all(color: Colors.blue, width: 5)),
                          child: new IconTheme(
                            data: new IconThemeData(
                                color: Colors.blue[400]),
                            child: new Icon(Icons.calendar_today),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left:10, top: 20.0),
                          child:Text('Horário do Remédio \n' ,
                            style: TextStyle(fontSize: 20.0, color: Colors.black),)
                        )

                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(80, 0, 10, 10),

                    child: Container(

                        width: 500.0,
                        height: 50.0,
                        child:   Text('  9h30 ',
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 40.0, color: Colors.black),)
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(80, 10, 10, 10),

                    child: Container(

                        width: 500.0,
                        height: 30.0,
                        child:   Text('  Losartana ',
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 20.0, color: Colors.black),)
                    ),
                  )
                ],
              )
          ),
          Container(
              width: 200.0,
              height: 200.0,

              margin: EdgeInsets.symmetric(horizontal: 10.0),
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
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          //decoration: BoxDecoration(border: Border.all(color: Colors.blue, width: 5)),
                          child: new IconTheme(
                            data: new IconThemeData(
                                color: Colors.blue[400]),
                            child: new Icon(Icons.calendar_today),
                          ),
                        ),
                        Container(
                            padding: const EdgeInsets.only(left:10, top: 20.0),
                            child:Text('Horário do Remédio \n' ,
                              style: TextStyle(fontSize: 20.0, color: Colors.black),)
                        )

                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(85, 0, 10, 10),

                    child: Container(

                        width: 500.0,
                        height: 50.0,
                        child:   Text('  14h30 ',
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 40.0, color: Colors.black),)
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(80, 10, 10, 10),

                    child: Container(

                        width: 500.0,
                        height: 30.0,
                        child:   Text('  Exemplo ',
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 20.0, color: Colors.black),)
                    ),
                  )
                ],
              )
          )
        ],

      ),
    );
  }
}