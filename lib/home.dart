import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vampir/classes/lobby_functions.dart';
import 'package:vampir/classes/widgets.dart';
import 'package:vampir/lobby.dart';
import 'classes/player.dart';

class Home extends StatefulWidget {
  final Player player;
  const Home({Key key, this.player}) : super(key: key);

  @override
  _HomeState createState() => _HomeState(player);
}

class _HomeState extends State<Home> {
  final Player player;
  final sessionIDController = TextEditingController();
  String sessionID;
  var numberOfVampires;

  _HomeState(this.player);

  @override
  void initState() {
    super.initState();
    sessionIDController.addListener(_changeSessionID);
  }

  @override
  void dispose() {
    sessionIDController.dispose();
    super.dispose();
  }

  _changeSessionID() {
    sessionID = sessionIDController.text;
  }

  Future<bool> doesExist(String sessionID) async {
    try {
      Firestore.instance.collection(sessionID).getDocuments();
      return true;
    } catch (e) {
      print(e.message);
      return false;
    }
  }

  Widget joinGameButton(BuildContext context, String sessionID) {
    return FlatButton(
      child: Text(
        'Join the Game',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      onPressed: () async {
        bool check = await doesExist(sessionID);
        if (sessionID != null && check) {
          player.isAdmin = false;
          await addPlayer(player, sessionID);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Lobby(
                player: player,
                sessionID: sessionID,
              ),
            ),
          );
        } else {
          Scaffold.of(context)
              .showSnackBar(snackbar('Blank or invalid Session ID!'));
        }
      },
    );
  }

  Widget startGameButton(String newSessionID, BuildContext context) {
    return RaisedButton(
      color: Colors.black,
      textColor: Colors.white,
      child: Text('Create'),
      onPressed: () async {
        if (numberOfVampires != null) {
          await createGame(player, newSessionID);
          Firestore.instance
              .collection(newSessionID)
              .document('Game Settings')
              .setData({
            'vampireCount': numberOfVampires,
            'isInLobby': true,
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => Lobby(
                player: player,
                sessionID: newSessionID,
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
    return StatefulBuilder(
      builder: (BuildContext context, setState) {
        return Center(
          child: DropdownButton<int>(
            hint: Text(
              'Number of Vampires',
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
            value: numberOfVampires,
            icon: Icon(Icons.arrow_downward, color: Colors.black),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.black, fontSize: 20),
            underline: Container(
              height: 2,
              color: Colors.black,
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
      },
    );
  }

  void createTheGame(BuildContext context) {
    var newSessionID = Random().nextInt(1000000).toString();
    showModalBottomSheet(
      elevation: 10,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 225,
          child: Column(
            children: [
              SizedBox(height: 25),
              Text(
                'Select the Number of Vampires',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 10),
              dropdownMenu(),
              SizedBox(height: 50),
              startGameButton(newSessionID, context),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      backgroundColor: Colors.transparent,
      floatingActionButton: Builder(
        builder: (BuildContext context) {
          return floatingAction(
            icon: Icons.add,
            label: 'Create New Game',
            onpressed: () => createTheGame(context),
          );
        },
      ),
      body: Builder(
        builder: (BuildContext context) {
          return SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: 200),
                Text(
                  'Welcome, ${player.name}',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                SizedBox(height: 75),
                textInput(
                    controller: sessionIDController,
                    hintText: 'Session ID',
                    //icon: Icon(Icons.confirmation_number, color: Colors.white),
                    keyboardType: TextInputType.number),
                joinGameButton(context, sessionID),
              ],
            ),
          );
        },
      ),
    );
  }
}
