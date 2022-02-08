import 'package:flutter/material.dart';

class PageViewDados extends StatefulWidget {
  @override
  _PageViewDados createState() => _PageViewDados();
}

class _PageViewDados extends State<PageViewDados> {
  var controller = PageController(
    viewportFraction: 1,
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(vertical: 10.0),
      height: 200.0,
      width: 500,
      child: PageView(
        controller: controller,
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          InkWell(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                image: new DecorationImage(
                  image: new ExactAssetImage('imagens/Grafico.png'),
                  scale: 30,
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            child:
                ListView(padding: const EdgeInsets.all(8), children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(vertical: 5.0),
                height: 50,
                color: Colors.grey[200],
                child: Center(
                    child: RichText(
                  text: TextSpan(
                    text: '11 de Agosto      ',
                    style: DefaultTextStyle.of(context).style,
                    children: const <TextSpan>[
                      TextSpan(
                          text: '14',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.red)),
                      TextSpan(text: ' /'),
                      TextSpan(
                          text: '9',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.blue)),
                    ],
                  ),
                )),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5.0),
                height: 50,
                color: Colors.grey[200],
                child: Center(
                    child: RichText(
                  text: TextSpan(
                    text: '16 de Agosto      ',
                    style: DefaultTextStyle.of(context).style,
                    children: const <TextSpan>[
                      TextSpan(
                          text: '15',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.red)),
                      TextSpan(text: ' /'),
                      TextSpan(
                          text: '10',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.blue)),
                    ],
                  ),
                )),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5.0),
                height: 50,
                color: Colors.grey[200],
                child: Center(
                    child: RichText(
                  text: TextSpan(
                    text: '23 de Agosto      ',
                    style: DefaultTextStyle.of(context).style,
                    children: const <TextSpan>[
                      TextSpan(
                          text: '14',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.red)),
                      TextSpan(text: ' /'),
                      TextSpan(
                          text: '8',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.blue)),
                    ],
                  ),
                )),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5.0),
                height: 50,
                color: Colors.grey[200],
                child: Center(
                    child: RichText(
                  text: TextSpan(
                    text: '28 de Agosto      ',
                    style: DefaultTextStyle.of(context).style,
                    children: const <TextSpan>[
                      TextSpan(
                          text: '13',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.red)),
                      TextSpan(text: ' /'),
                      TextSpan(
                          text: '9',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.blue)),
                    ],
                  ),
                )),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5.0),
                height: 50,
                color: Colors.grey[200],
                child: Center(
                    child: RichText(
                  text: TextSpan(
                    text: '30 de Agosto      ',
                    style: DefaultTextStyle.of(context).style,
                    children: const <TextSpan>[
                      TextSpan(
                          text: '15',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.red)),
                      TextSpan(text: ' /'),
                      TextSpan(
                          text: '9',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.blue)),
                    ],
                  ),
                )),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
