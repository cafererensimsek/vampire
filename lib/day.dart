import 'package:flutter/material.dart';
import 'package:vampir/shared/widgets.dart';
import 'package:vampir/logic/day_logic.dart';
import 'shared/player.dart';

class Day extends StatefulWidget {
  final Player player;
  final String sessionID;

  const Day({Key key, this.player, this.sessionID}) : super(key: key);
  @override
  _DayState createState() => _DayState(player, sessionID);
}

class _DayState extends State<Day> {
  final Player player;
  final String sessionID;

  _DayState(this.player, this.sessionID);
  @override
  Widget build(BuildContext context) {
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
