import 'package:flutter/material.dart';
import 'package:vampir/classes/lobby_functions.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          child: Text('Welcome ${player.name}'),
          fit: BoxFit.fitWidth,
        ),
        centerTitle: true,
      ),
      body: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NewGame(admin: player)));
          },
          label: Text('Create new game'),
          icon: Icon(Icons.add),
          shape: RoundedRectangleBorder(),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 50),
            Column(children: [
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
              FlatButton(
                onPressed: () async {
                  player.isAdmin = false;
                  await HandleLobby().addPlayer(player, sessionID);
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
            ]),
          ],
        ),
      ),
    );
  }
}
