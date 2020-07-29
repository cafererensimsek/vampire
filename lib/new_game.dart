import 'dart:math';
import 'package:flutter/material.dart';
import 'create_player_list.dart';
import 'player.dart';

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

  Widget startTheGame(context) {
    return FloatingActionButton.extended(
      onPressed: () async {
        var admin = new Player(name: adminEmail, isAdmin: true, isAlive: true);
        await CreateList(admin: admin, sessionID: sessionID).createList();
        Navigator.push(context, MaterialPageRoute(builder: (context) => null));
      },
      label: Text('Start the game'),
      icon: Icon(Icons.add),
      shape: RoundedRectangleBorder(),
    );
  }

  Widget gameSettings(context) {
    return Scaffold(
      floatingActionButton: startTheGame(context),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Session ID: $sessionID'),
        centerTitle: true,
      ),
      body: gameSettings(context),
    );
  }
}
