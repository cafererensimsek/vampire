import 'dart:math';
import 'package:flutter/material.dart';
import 'package:vampir/Screens/lobby.dart';
import '../Classes/create_player_list.dart';
import '../Classes/player.dart';

class NewGame extends StatefulWidget {
  final String adminEmail;
  const NewGame({Key key, @required this.adminEmail}) : super(key: key);

  @override
  _NewGameState createState() => _NewGameState(this.adminEmail);
}

class _NewGameState extends State<NewGame> {
  final String adminEmail;

  _NewGameState(this.adminEmail);

  var sessionID = Random().nextInt(1000000);
  var numberOfVampires = 1;
  var numberOfVillagers = 1;

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
              email: adminEmail,
              isAdmin: true,
              isAlive: true,
              isWaiting: true,
            );
            // creates a collection in firestore with the name sessionID
            await CreateList(admin: admin, sessionID: sessionID)
                .createCollection();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Lobby(
                  player: admin,
                  sessionID: sessionID.toString(),
                ),
              ),
            );
          },
          label: Text('Go to the Lobby'),
          icon: Icon(Icons.add),
          shape: RoundedRectangleBorder(),
        ),

        // select two values for the game settings
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(children: [
              Container(
                child: Text('Number of vampires: '),
                padding: EdgeInsets.all(50),
              ),
              Container(
                padding: EdgeInsets.all(50),
                child: DropdownButton(
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Theme.of(context).accentColor),
                    underline: Container(
                      height: 2,
                      color: Theme.of(context).accentColor,
                    ),
                    value: numberOfVampires,
                    items: [1, 2, 3, 4, 5].map((var value) {
                      return DropdownMenuItem(
                        child: Text(value.toString()),
                        value: value,
                      );
                    }).toList(),
                    onChanged: (var newValue) {
                      setState(() {
                        numberOfVampires = newValue;
                        print(numberOfVampires);
                      });
                    }),
              ),
            ]),
            Row(children: [
              Container(
                child: Text('Number of villagers: '),
                padding: EdgeInsets.all(50),
              ),
              Container(
                padding: EdgeInsets.all(50),
                child: DropdownButton(
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Theme.of(context).accentColor),
                    underline: Container(
                      height: 2,
                      color: Theme.of(context).accentColor,
                    ),
                    value: numberOfVillagers,
                    items: [1, 2, 3, 4, 5].map((var value) {
                      return DropdownMenuItem(
                        child: Text(value.toString()),
                        value: value,
                      );
                    }).toList(),
                    onChanged: (var newValue) {
                      setState(() {
                        numberOfVillagers = newValue;
                        print(numberOfVillagers);
                      });
                    }),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
