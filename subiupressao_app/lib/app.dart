import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:subiupressao_app/app_celular/Components/Controller.dart';
import 'package:subiupressao_app/app_celular/Consultas/Appointments.dart';
import 'package:subiupressao_app/app_celular/Profile/Profile.dart';
import 'package:subiupressao_app/app_celular/Remedios/Medicines.dart';

import 'package:subiupressao_app/files/FileController.dart';
import 'package:subiupressao_app/tabItem.dart';
import 'package:subiupressao_app/app_celular/bottomNavigation.dart';
import 'package:subiupressao_app/bluetooth/connection/connectionPage.dart';
import 'package:subiupressao_app/bluetooth/heart/heartRatePage.dart';
import 'dataClass.dart';

class App extends StatefulWidget {
  //App({Key key, @required this.Hr}) : super(key: key);
  Controller controller;

  App({this.controller});

  @override
  State<StatefulWidget> createState() => AppState(controller: controller);
}

class AppState extends State<App> {
  // this is static property so other widget throughout the app
  // can access it simply by AppState.currentTab
  static int currentTab = 2;
  final myData data = myData(-1);
  Controller controller;

  //  list tabs here
  List<TabItem> tabs;

  AppState({this.controller}) {
    tabs = [
      // telas no Navigation Bar
      TabItem(
        tabName: "Remédios",
        icon: MaterialCommunityIcons.pill,
        page: Medicines(controller: controller),
      ),
      TabItem(
        tabName: "Pressão",
        icon: MaterialCommunityIcons.heart_pulse,
        page: HeartRatePage(controller: controller),
      ),
      TabItem(
        tabName: "Perfil",
        icon: Icons.person,
        page: Profile(controller: controller),
      ),
      TabItem(
        tabName: "Conectar",
        icon: Icons.bluetooth_searching,
        page: connectionPage(),
      ),
      TabItem(
        tabName: "Consultas",
        icon: Icons.assignment_ind_rounded,
        page: Appointments(controller: controller),
      ),
    ];

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
    if (controller.user == null) {
      controller.updateUser(
        newUser: context.select(
          (FileController fileController) {
            fileController.readUser();
            return fileController.user;
          },
        ),
      );
    }

    if (controller.dateTime == null) {
      controller.updateDateTime(newDateTime: DateTime.now());
    }

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
