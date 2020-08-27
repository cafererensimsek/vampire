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

  Widget createGameButton(BuildContext context) {
    return floatingAction(
      icon: Icons.add,
      label: 'Go to Lobby',
      onpressed: () async {
        if (numberOfVampires != null) {
          await createGame(admin, sessionID);
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
              .showSnackBar(snackbar('You must choose the number of vampires'));
        }
      },
    );
  }

  Widget dropdownMenu() {
    return Center(
      child: DropdownButton<int>(
        hint: Text(
          'Number of Vampires',
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
        value: numberOfVampires,
        icon: Icon(Icons.arrow_downward, color: Colors.white),
        iconSize: 24,
        elevation: 16,
        style: TextStyle(color: Colors.amber, fontSize: 20),
        underline: Container(
          height: 2,
          color: Colors.white,
        ),
        onChanged: (int newValue) {
          setState(() {
            numberOfVampires = newValue;
          });
        },
        items: <int>[1, 2, 3, 4, 5].map<DropdownMenuItem<int>>((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text(value.toString()),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('lib/assets/background.jpg'),
              fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: Builder(builder: (BuildContext context) {
          return createGameButton(context);
        }),
        body:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Text(
            'Session ID: $sessionID',
            style: TextStyle(fontSize: 25, color: Colors.white),
          ),
          dropdownMenu(),
        ]),
      ),
    );
  }
}
