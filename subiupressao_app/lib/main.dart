import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:subiupressao_app/app_celular/Login/Login.dart';
import 'package:subiupressao_app/bluetooth/connection/connectionPage.dart';
import 'package:subiupressao_app/files/FileController.dart';

// Aqui a inicializacao começa e o NavigationBar é setado
// A primeira tela é a tela central e está no arquivo CentralPage.dart
void main() async {
  await initializeDateFormatting();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => FileController()),
    ],
    child: MyApp(),
  ));
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
      home: LoginPage(),
    );
  }
}
