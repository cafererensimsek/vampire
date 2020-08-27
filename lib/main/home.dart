import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vampir/classes/lobby_functions.dart';
import 'package:vampir/classes/widgets.dart';
import 'package:vampir/settings/lobby.dart';
import 'package:vampir/settings/new_game.dart';
import '../classes/player.dart';

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

  Widget newGameButton() {
    return floatingAction(
      icon: Icons.add,
      label: 'Create New Game',
      onpressed: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => NewGame(admin: player))),
    );
  }

  Widget sessionIdInput() {
    return textInput(
        controller: sessionIDController,
        hintText: 'Session ID',
        icon: Icon(Icons.confirmation_number, color: Colors.white),
        keyboardType: TextInputType.number);
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
        floatingActionButton: newGameButton(),
        body: Builder(
          builder: (BuildContext context) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome, ${player.name}',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                SizedBox(height: 150),
                sessionIdInput(),
                SizedBox(height: 20),
                joinGameButton(context, sessionID),
              ],
            );
          },
        ),
      ),
    );
  }
}
