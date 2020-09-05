import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vampir/classes/player.dart';
import 'classes/lobby_functions.dart';
import 'classes/widgets.dart';
import 'home_user.dart';
import 'lobby.dart';

class Home extends StatefulWidget {
  final FirebaseUser user;

  const Home({Key key, this.user}) : super(key: key);
  @override
  _HomeState createState() => _HomeState(user);
}

class _HomeState extends State<Home> {
  final FirebaseUser user;
  final sessionIDController = TextEditingController();
  String sessionID;
  int numberOfVampires;
  Player player;
  bool check = false;
  int _index = 0;

  _HomeState(this.user);

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
      return false;
    }
  }

  Widget joinGameButton(BuildContext context, String sessionID) {
    return FlatButton(
      child: Text(
        'Join Game',
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
    String newSessionID = Random().nextInt(1000000).toString();
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
      backgroundColor: Colors.black,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Builder(
        builder: (BuildContext context) {
          return FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () => createTheGame(context),
          );
        },
      ),
      body: _index == 1
          ? Builder(
              builder: (BuildContext context) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                    SizedBox(height: 30),
                    textInput(
                      controller: sessionIDController,
                      hintText: 'Session ID',
                      keyboardType: TextInputType.number,
                    ),
                    joinGameButton(context, sessionID),
                  ],
                );
              },
            )
          : HomeUser(user: user),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () => setState(() => _index = 0),
            ),
            IconButton(
              icon: Icon(Icons.play_arrow),
              onPressed: () => setState(() => _index = 1),
            ),
          ],
        ),
      ),
    );
  }
}
