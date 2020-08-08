import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vampir/Classes/player.dart';
import 'package:vampir/Screens/Game_Screens/night.dart';

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
    //String vampireKill;

    Firestore.instance
        .collection(sessionID)
        .document('Game Settings')
        .collection('Night Values')
        .document('Villager Kill')
        .get()
        .then((value) => villagerKill = value.data['Villager Kill']);

/*     Firestore.instance
        .collection(sessionID)
        .document('Game Settings')
        .collection('Night Values')
        .document('Vampire Kill')
        .get()
        .then((value) => vampireKill = value.data['Vampire Kill']); */

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        // start the game, push the admin to first night
        onPressed: player.isAdmin
            ? () {
                Firestore.instance
                    .collection(sessionID)
                    .document('Game Settings')
                    .setData({'didDayEnd': true}, merge: true);
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
            : () {
                Firestore.instance
                    .collection(sessionID)
                    .document('Game Settings')
                    .get()
                    .then((value) {
                  if (value.data['didDayEnd'] == true) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Night(
                          player: player,
                          sessionID: sessionID,
                        ),
                      ),
                    );
                  }
                });
              },
        label: Text('End the Day'),
        shape: RoundedRectangleBorder(),
      ),
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 25),
          child: Text('It\'s Day. You are a ${player.role}'),
        ),
      ),
      body: Column(
        children: [
          Text('Villagers killed: $villagerKill'),
          //Text('Villagers killed: $vampireKill'),
        ],
      ),
    );
  }
}
