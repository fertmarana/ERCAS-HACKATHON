import 'package:flutter/material.dart';

import 'package:subiupressao_app/app_celular/PageView_Remedios.dart';

// Here the residents can check their data such as their waste collection history,
// their registered adresses and their statistics.

String readifyDateTime(DateTime date) {
  // Não achei nenhuma forma melhor de fazer a exibição da data em string por
  // extenso, então montei essa funçãozinha aqui pra fazer isso
  // Se eu descobrir alguma forma melhor, eu atualizo isso aqui

  List<String> months = [
    "",
    "JANEIRO",
    "FEVEREIRO",
    "MARÇO",
    "ABRIL",
    "MAIO",
    "JUNHO",
    "JULHO",
    "AGOSTO",
    "SETEMBRO",
    "OUTUBRO",
    "NOVEMBRO",
    "DEZEMBRO",
  ];

  return "${date.day} DE ${months[date.month]}, ${date.year}";
}

class Remedios extends StatefulWidget {
  // Transformei essa classe em Stateful unicamente por conta dessa variável
  // _dateTime, mas no curso que vi falava que o ideal seria colocar apenas a
  // parte que altera em um StatefulWidget, mas para manter a padronização dos
  // arquivos atuais resolvi deixar tudo aqui mesmo

  DateTime _dateTime = DateTime.now();

  @override
  State<Remedios> createState() => _RemediosState();
}

class _RemediosState extends State<Remedios> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 40, 10, 10),
      child: Wrap(children: [
        // header
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                showDatePicker(
                        context: context,
                        initialDate: widget._dateTime,
                        firstDate: DateTime(2010),
                        lastDate: DateTime(2200))
                    .then((date) {
                  setState(() {
                    widget._dateTime = date == null ? widget._dateTime : date;
                  });
                });
              },
              icon: const Icon(Icons.calendar_today_rounded, size: 30),
            ),
            Spacer(),
            Text(
              readifyDateTime(widget._dateTime),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.add_box, size: 40),
            ),
          ],
        ),
        Card(
            margin: EdgeInsets.fromLTRB(30, 15, 30, 15),
            elevation: 5,
            color: const Color(0xff00ffe0),
            child: Row(
              children: [
                SizedBox(width: 15,),
                Column(
                  children: [
                    SizedBox(height: 15,),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: Image.asset(
                        'imagens/fotoperfil.png',
                        fit: BoxFit.cover,
                        height: 70,
                        width: 70,
                      ),
                    ),
                    SizedBox(height: 15,),
                  ],
                ),
                SizedBox(width: 20,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Olá, Astolfo!", style: TextStyle(fontSize: 16),),
                    SizedBox(height: 2,),
                    Text("Hoje você tem de tomar", style: TextStyle(fontSize: 16),),
                    SizedBox(height: 5,),
                    Text(
                      "1 remédio",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            )),
        PageView_Remedios(),
      ]),
    );
  }
}
