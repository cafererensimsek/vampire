import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vampir/Classes/create_player_list.dart';
import 'package:vampir/Classes/player.dart';

import 'lobby.dart';

class NewGame extends StatefulWidget {
  final String adminEmail;
  const NewGame({Key key, @required this.adminEmail}) : super(key: key);

  @override
  _NewGameState createState() => _NewGameState(this.adminEmail);
}

class _NewGameState extends State<NewGame> {
  final String adminEmail;

  _NewGameState(this.adminEmail);

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
          // creates an admin user and sends him to the lobby of his game
          onPressed: () async {
            var admin = new Player(
                name: adminEmail.substring(0, adminEmail.indexOf('@')),
                email: adminEmail,
                isAdmin: true,
                isAlive: true,
                role: 'villager');
            // creates a collection in firestore with the name sessionID
            await CreateList(admin: admin, sessionID: sessionID)
                .createCollection();
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

        // select the vampire count
        body: Center(
          child: DropdownButton<int>(
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
