import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vampir/classes/player.dart';
import 'package:vampir/classes/widgets.dart';
import 'package:vampir/home.dart';
import 'package:vampir/logic/lobby_logic.dart';

Widget playerList(
  BuildContext context,
  Player player,
  CollectionReference database,
  Map<String, String> players,
) {
  return ListView(
    children: [
      for (String playerID in players.keys)
        Card(
          color: Theme.of(context).primaryColor,
          child: ListTile(
            title: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(playerID, style: TextStyle(color: Colors.white)),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(players[playerID],
                  style: TextStyle(color: Colors.white)),
            ),
            onTap: () => deletePlayer(database, playerID, player),
            leading: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Icon(Icons.person, color: Colors.white),
            ),
            trailing: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Icon(Icons.delete, color: Colors.white),
            ),
          ),
        ),
    ],
  );
}

dynamic playerListDisplay(BuildContext context, CollectionReference database,
    Player player, String sessionID) {
  DocumentSnapshot currentData = Provider.of<DocumentSnapshot>(context);

  bool inSession = false;
  currentData != null ? inSession = currentData.data['inSession'] : null;

  if (inSession) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: floatingAction(
          onpressed: () => startGame(database, player, context, sessionID),
          label: 'Start',
          icon: Icons.arrow_forward_ios),
      appBar: AppBar(
        title: Text("Session ID:$sessionID"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.shuffle),
            onPressed:
                player.isAdmin ? () => assignRoles(database, player) : null,
          ),
          IconButton(
            icon: Icon(Icons.restore),
            onPressed: () => resetRoles(database, sessionID, player),
          ),
        ],
      ),
      body: playerList(context, player, database, getCurrentPlayers(context)),
    );
  } else {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'You\'ve been kicked out! \n\nYou will be redirected to the home page.',
            style: TextStyle(color: Colors.white, fontSize: 30),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 75),
          FlatButton(
            color: Colors.transparent,
            onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (BuildContext context) => Home(email: player.email),
                ),
                (route) => false),
            child: Text(
              'OK',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
        ],
      ),
    );
  }
}
