import 'package:flutter/material.dart';
import 'tabItem.dart';
import 'app_celular/bottomNavigation.dart';
import 'package:subiupressao_app/app_celular/CentralPage.dart';
import 'package:subiupressao_app/app_celular/minhaConta.dart';
import 'package:subiupressao_app/app_celular/Lembretes.dart';
import 'package:subiupressao_app/bluetooth/Bluetooth_test.dart';
import 'package:subiupressao_app/bluetooth/connectionPage.dart';
import 'package:subiupressao_app/bluetooth/heartRatePage.dart';
import 'package:subiupressao_app/globals.dart' as globals;

class App2 extends StatefulWidget {

  //App({Key key, @required this.Hr}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AppState();
}

class AppState extends State<App2> {
  int _currentIndex = 0;
  final List _children = [];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Flutter App'),
      ),
      body: _children[_currentIndex], // new
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.mail),
            title: Text('Messages'),
          ),
          new BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Profile')
          )
        ],
      ),
    );
  }
}