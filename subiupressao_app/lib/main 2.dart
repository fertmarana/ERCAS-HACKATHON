import 'package:flutter/material.dart';
import 'package:subiupressao_app/CatadorouMorador.dart';
import 'package:intl/date_symbol_data_local.dart';

//Here the initialization starts and a bottom navigationbar is set
// The first screen open for the Resident and the Scavegner is in the
// files CentralPage.dart (for Resident) and CentralPage_catadores.dart (Scavegner)
void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp( 
      title: 'Bottom Navigation Bar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CatadorOuMorador(),
    );
  }
}