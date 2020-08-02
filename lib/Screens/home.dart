import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vampir/Classes/add_player.dart';
import 'lobby.dart';
import 'new_game.dart';
import '../Classes/player.dart';

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
      ),
      SizedBox(height: 25),
      FlatButton(
        onPressed: () async {
          Player player = new Player(
              email: widget.user.email,
              isAlive: true,
              isAdmin: false,
              isWaiting: true);
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

  Widget homePageBody(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 50),
        SizedBox(height: 50),
        joinGame(context),
      ],
    );
  }

  Widget startNewGame(context) {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NewGame(adminEmail: widget.user.email)));
      },
      label: Text('Create new game'),
      icon: Icon(Icons.add),
      shape: RoundedRectangleBorder(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          child: Text('Welcome ${widget.user.email}'),
          fit: BoxFit.fitWidth,
        ),
        centerTitle: true,
      ),
      body: Scaffold(
        floatingActionButton: startNewGame(context),
        body: homePageBody(context),
      ),
    );
  }
}
