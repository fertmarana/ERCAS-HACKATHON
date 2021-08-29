import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

// This Screen is not fully implemented yet but it was intented to show
// the waste collection apointments of the residents.

class agenda_morador extends StatefulWidget {
  @override
  _agenda_morador createState() => _agenda_morador();
}

class _agenda_morador extends State<agenda_morador> {
  CalendarController _controller = CalendarController();
  Map<DateTime, List> _events;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = CalendarController();
    _events = {
      DateTime.utc(2019, 11, 5, 12): ['Event 1'],
      DateTime.utc(2019, 11, 6, 12): ['Event 2'],
    };
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addEvent() {
    final random = Random();
    final randomValue = random.nextInt(99) + 1;

    final day = _controller.selectedDay;
    final event = 'Random event $randomValue';

    setState(() {
      _events.update(
        day,
            (previousEvents) => previousEvents..add(event),
        ifAbsent: () => [event],
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
         backgroundColor: Colors.transparent,
          title: const Text('',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
          ),
      ),
      body: Container(
        alignment: Alignment(1.0,1.0),
        child: Column(
        children: <Widget>[
          TableCalendar(
              locale: 'pt_br',
              calendarController: _controller,
          ),
        ],
        )
      )
    );
  }
}