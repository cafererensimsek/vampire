import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vampir/classes/day_end_functions.dart';
import 'package:vampir/classes/widgets.dart';
import 'package:vampir/main/home.dart';
import '../classes/player.dart';
import 'night.dart';

class Day extends StatefulWidget {
  final String sessionID;
  final Player player;

  const Day({Key key, this.sessionID, this.player}) : super(key: key);

  @override
  _DayState createState() => _DayState(sessionID, player);
}

class _DayState extends State<Day> {
  final String sessionID;
  final Player player;

  _DayState(this.sessionID, this.player);

  @override
  Widget build(BuildContext context) {
    String villagerKill;
    String vampireKill;

    Firestore.instance
        .collection(sessionID)
        .document('Game Settings')
        .collection('Night Values')
        .document('Villager Kill')
        .get()
        .then((value) => villagerKill = value.data['Villager Kill']);

    Firestore.instance
        .collection(sessionID)
        .document('Game Settings')
        .collection('Night Values')
        .document('Vampire Kill')
        .get()
        .then((value) => vampireKill = value.data['Vampire Kill']);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        label: Text('End the Day'),
        shape: RoundedRectangleBorder(),
        onPressed: player.isAdmin
            ? () {
                EndDay().setSettings(sessionID);
                if (player.name == villagerKill || player.name == vampireKill) {
                  EndDay().setNewAdmin(sessionID, villagerKill, vampireKill);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Home(),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Night(
                        sessionID: sessionID,
                        player: player,
                      ),
                    ),
                  );
                }
              }
            : () {
                Firestore.instance
                    .collection(sessionID)
                    .document('Game Settings')
                    .get()
                    .then((value) {
                  if (value.data['didDayEnd'] == true) {
                    if (player.name != villagerKill ||
                        player.name != vampireKill) {
                      EndDay().setPlayerAdmin(sessionID, player);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Night(
                            player: player,
                            sessionID: sessionID,
                          ),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Home(
                            player: player,
                          ),
                        ),
                      );
                    }
                  } else {
                    Widgets().snackbar('Wait for admin to end the night!');
                  }
                });
              },
      ),
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 25),
          child: Text('It\'s Day. You are a ${player.role}.'),
        ),
      ),
      body: Column(
        children: [
          Text('Villagers killed: $villagerKill'),
          Text('Villagers killed: $vampireKill'),
        ],
      ),
    );
  }
}
