import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vampir/classes/lobby_functions.dart';
import 'package:vampir/classes/widgets.dart';
import '../classes/player.dart';
import 'lobby.dart';

class NewGame extends StatefulWidget {
  final Player admin;
  const NewGame({Key key, @required this.admin}) : super(key: key);

  @override
  _NewGameState createState() => _NewGameState(this.admin);
}

class _NewGameState extends State<NewGame> {
  final Player admin;

  _NewGameState(this.admin);

  var sessionID = Random().nextInt(1000000).toString();
  var numberOfVampires;

  void goToLobby() async {
    if (numberOfVampires != null) {
      await HandleLobby().createGame(admin, sessionID);
      Firestore.instance
          .collection(sessionID)
          .document('Game Settings')
          .setData({
        'vampireCount': numberOfVampires,
        'isInLobby': true,
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Lobby(
            player: admin,
            sessionID: sessionID,
          ),
        ),
      );
    } else {
      Scaffold.of(context)
          .showSnackBar(Widgets().snackbar('Choose the number of vampires'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        floatingActionButton: Widgets().floatingAction(
            icon: Icons.add, label: 'Go to Lobby', onpressed: goToLobby),
        body:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Text(
            'Session ID: $sessionID',
            style: TextStyle(fontSize: 20),
          ),
          Center(
            child: DropdownButton<int>(
              hint: Text('Number of Vampries'),
              value: numberOfVampires,
              icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Theme.of(context).accentColor,
              ),
              onChanged: (int newValue) {
                setState(() {
                  numberOfVampires = newValue;
                });
              },
              items:
                  <int>[1, 2, 3, 4, 5].map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
            ),
          ),
        ]),
      ),
    );
  }
}
