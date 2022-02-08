import 'package:flutter/material.dart';
import 'tabItem.dart';
import 'app_celular/bottomNavigation.dart';
import 'package:subiupressao_app/app_celular/CentralPage.dart';
import 'package:subiupressao_app/app_celular/minhaConta.dart';
import 'package:subiupressao_app/app_celular/Lembretes.dart';
import 'package:subiupressao_app/bluetooth/Bluetooth_test.dart';
import 'package:subiupressao_app/bluetooth/connection/connectionPage.dart';
import 'package:subiupressao_app/bluetooth/HeartRate/heartRatePage.dart';
import 'package:subiupressao_app/globals.dart' as globals;
class App1 extends StatefulWidget {

  //App({Key key, @required this.Hr}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AppState();
}

class AppState extends State<App1> {
  // this is static property so other widget throughout the app
  // can access it simply by AppState.currentTab
  @override
  String text = 'Home';
  int _currIndex = 0;

  _onTap(int index) {
    setState(() => _currIndex = index);
    switch (index) {
      case 0:
        Navigator.of(context)
            .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
          return new DataPage(data: 'Home');
        }));
        break;
      case 1:
        Navigator.of(context)
            .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
          return new DataPage(data: 'Favorite');
        }));
        break;
      case 2:
        Navigator.of(context)
            .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
          return new DataPage(data: 'Profile');
        }));
        break;
      case 3:
        Navigator.of(context)
            .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
          return new DataPage(data: 'Settings');
        }));
        break;
      default:
        Navigator.of(context)
            .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
          return new DataPage(data: 'Home');
        }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[900],
        title: Text("Bottom Nav Bar"),
      ),
      body: Center(
        child: Text(text,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currIndex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favorite",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
        onTap: _onTap,
      ),
    );
  }
}

class DataPage extends StatelessWidget {
  final String data;

  const DataPage({Key key, this.data}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.red[900],
          title: Text("Data Page")),
      body: Center(
          child: Text(data,
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold))),
    );
  }
}

