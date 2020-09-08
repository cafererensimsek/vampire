import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vampir/shared/player.dart';
import 'package:vampir/shared/widgets.dart';
import 'package:vampir/home.dart';
import 'package:vampir/logic/lobby_logic.dart';

import '../night.dart';

dynamic playerListDisplay(
  BuildContext context,
  CollectionReference database,
  Player player,
  String sessionID,
) {
  DocumentSnapshot currentData = Provider.of<DocumentSnapshot>(context);
  Map<String, List<String>> players = getCurrentPlayers(context);
  List<String> vampires;

  players.forEach((key, value) {
    if (players[key][2] == 'vampire') {
      vampires.add(players[key][1]);
    }
  });

  bool inSession = false;
  bool isAdmin = false;
  bool inLobby = true;
  bool atNight = false;

  if (currentData != null) {
    inSession = currentData.data['inSession'];
    isAdmin = currentData.data['isAdmin'];
    inLobby = currentData.data['inLobby'];
    atNight = currentData.data['atNight'];
    player.role = currentData['role'];
  }

  if (inSession && isAdmin && inLobby) {
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
            onPressed: () => assignRoles(database, player),
          ),
          IconButton(
            icon: Icon(Icons.restore),
            onPressed: () => resetRoles(database, sessionID, player),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: players.keys.length,
        itemBuilder: (context, index) => Card(
          color: Theme.of(context).primaryColor,
          child: ListTile(
            title: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(players[index][1],
                  style: TextStyle(color: Colors.white)),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(players[index][0],
                  style: TextStyle(color: Colors.white)),
            ),
            onLongPress: () =>
                deletePlayer(database, players.keys.toList()[index], player),
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
      ),
    );
  } else if (inSession && !isAdmin && inLobby) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Session ID:$sessionID"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: players.keys.length,
        itemBuilder: (context, index) => Card(
          color: Theme.of(context).primaryColor,
          child: ListTile(
            title: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(players[index][1],
                  style: TextStyle(color: Colors.white)),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(players[index][0],
                  style: TextStyle(color: Colors.white)),
            ),
            leading: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Icon(Icons.person, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  } else if (inSession && !isAdmin && atNight) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'The game has started. \n\nClick below.',
            style: TextStyle(color: Colors.white, fontSize: 30),
            textAlign: TextAlign.center,
          ),
          if (vampires.contains(player.name))
            for (var vampire in vampires) Text(vampire),
          SizedBox(height: 75),
          FlatButton(
            color: Colors.transparent,
            onPressed: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        Night(player: player, sessionID: sessionID)),
                (route) => false),
            child: Text(
              'OK',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
        ],
      ),
    );
  } else if (!inSession) {
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
