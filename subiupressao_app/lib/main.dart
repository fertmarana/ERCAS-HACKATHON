import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:subiupressao_app/app.dart';

// Aqui a inicializacao começa e o NavigationBar é setado
// A primeira tela é a tela central e está no arquivo CentralPage.dart
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
      home: App(),
    );
  }
}