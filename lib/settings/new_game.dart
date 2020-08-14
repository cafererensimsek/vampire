import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vampir/classes/lobby_functions.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Session ID: $sessionID'),
        centerTitle: true,
      ),
      body: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
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
          },
          label: Text('Go to the Lobby'),
          icon: Icon(Icons.add),
          shape: RoundedRectangleBorder(),
        ),
        body: Center(
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
            items: <int>[1, 2, 3, 4, 5].map<DropdownMenuItem<int>>((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text(value.toString()),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
