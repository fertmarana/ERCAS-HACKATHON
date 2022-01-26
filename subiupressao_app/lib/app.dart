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
import 'dataClass.dart';

class App extends StatefulWidget {

  //App({Key key, @required this.Hr}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AppState();
}

class AppState extends State<App> {
  // this is static property so other widget throughout the app
  // can access it simply by AppState.currentTab
  static int currentTab = 1;
  final myData dataa = myData(-1);
  //int Hr;
  /*
  int heartR = -1;

  callback(newheartR) {
    setState(() {
      heartR = newheartR;
    });
  }*/


  // list tabs here
  final List<TabItem> tabs = [

// telas no Navigation Bar
    TabItem(
      tabName: "Perfil",
      icon: Icons.person,
      page: minhaConta_morador(),
    ),
    TabItem(
      tabName: "Início",
      icon: Icons.home,
      page: heartRatePage(),
    ),
    TabItem(
      tabName: "Lembretes",
      icon: Icons.menu_book_rounded ,
      page: //TestWrite(),
      connectionPage(),
      //Lembretes(),
    ),
  ];

  AppState() {
    // indexação é necessária para funcionar bem
    // em determinar qual tab no Navigation Bar está ativo
    tabs.asMap().forEach((index, details) {
      details.setIndex(index);
    });
  }

  // setando o index tab atual
  // e atualizando o estado
  void _selectTab(int index) {
    if (index == currentTab) {
      // pop to first route
      // if the user taps on the active tab
      tabs[index].key.currentState.popUntil((route) => route.isFirst);
    } else {
      // update the state
      // in order to repaint
      setState(() => currentTab = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    // WillPopScope handle android back btn
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
        !await tabs[currentTab].key.currentState.maybePop();
        if (isFirstRouteInCurrentTab) {
          // if not on the 'main' tab
          if (currentTab != 0) {
            // select 'main' tab
            _selectTab(0);
            // back button handled by app
            return false;
          }
        }
        // let system handle back button if we're on the first route
        return isFirstRouteInCurrentTab;
      },
      // this is the base scaffold
      // don't put appbar in here otherwise you might end up
      // with multiple appbars on one screen
      // eventually breaking the app
      child: Scaffold(
        // indexed stack shows only one child
        body: IndexedStack(
          index: currentTab,
          children: tabs.map((e) => e.page).toList(),
        ),
        // Bottom navigation
        bottomNavigationBar: BottomNavigation(
          onSelectTab: _selectTab,
          tabs: tabs,
        ),
      ),
    );
  }
}