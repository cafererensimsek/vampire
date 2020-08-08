// Either create a new game or join one

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vampir/Classes/add_player.dart';
import 'package:vampir/Screens/Setting_Screens/lobby.dart';
import 'package:vampir/Screens/Setting_Screens/new_game.dart';
import '../../Classes/player.dart';

class Home extends StatefulWidget {
  final FirebaseUser user;
  const Home({Key key, this.user}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final sessionIDController = TextEditingController();
  String sessionID;

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

  Widget joinGame(context) {
    return Column(children: [
      SizedBox(height: 75),
      TextField(
        controller: sessionIDController,
        decoration: InputDecoration(
          hintText: 'Session ID',
          icon: Icon(Icons.confirmation_number),
        ),
        keyboardType: TextInputType.number,
      ),
      SizedBox(height: 25),
      // creates a new non-admin user and sends him to the lobby of the
      // given sessionID
      FlatButton(
        onPressed: () async {
          Player player = new Player(
              name: widget.user.email
                  .substring(0, widget.user.email.indexOf('@')),
              email: widget.user.email,
              isAlive: true,
              isAdmin: true,
              role: 'villager');
          await AddPlayer(player: player, sessionID: sessionID)
              .addPlayer(player);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Lobby(
                player: player,
                sessionID: sessionID,
              ),
            ),
          );
        },
        child: Text('Join a Game'),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          child: Text(
              'Welcome ${widget.user.email.substring(0, widget.user.email.indexOf('@'))}'),
          fit: BoxFit.fitWidth,
        ),
        centerTitle: true,
      ),
      body: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          // sends the user to the settings page with their email
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        NewGame(adminEmail: widget.user.email)));
          },
          label: Text('Create new game'),
          icon: Icon(Icons.add),
          shape: RoundedRectangleBorder(),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 50),
            joinGame(context),
          ],
        ),
      ),
    );
  }
}
