import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vampir/classes/day_functions.dart';
import 'package:vampir/classes/widgets.dart';
import 'package:vampir/home.dart';
import '../classes/player.dart';

class Day extends StatefulWidget {
  @override
  _DayState createState() => _DayState();
}

class _DayState extends State<Day> {
  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    String sessionID = arguments['SessionID'];
    Player player = arguments['player'];
    String villagerKill;
    String vampireKill;

    return Scaffold(
      floatingActionButton:
          floatingAction(onpressed: endDay, label: 'End the Day'),
      body: Column(
        children: [
          Text('Villagers killed: $villagerKill'),
          Text('Villagers killed: $vampireKill'),
        ],
      ),
    );
  }
}
