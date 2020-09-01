import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vampir/classes/day_end_functions.dart';
import 'package:vampir/classes/widgets.dart';
import 'package:vampir/home.dart';
import '../classes/player.dart';
import 'night.dart';

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

    void endDay() {
      if (player.isAdmin) {
        setSettings(sessionID);
        if (player.name == villagerKill || player.name == vampireKill) {
          setNewAdmin(sessionID, villagerKill, vampireKill);
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
      } else {
        Firestore.instance
            .collection(sessionID)
            .document('Game Settings')
            .get()
            .then((value) {
          if (value.data['didDayEnd'] == true) {
            if (player.name != villagerKill || player.name != vampireKill) {
              setPlayerAdmin(sessionID, player);
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
            snackbar('Wait for admin to end the night!');
          }
        });
      }
    }

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
