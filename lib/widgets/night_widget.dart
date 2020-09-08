import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vampir/day.dart';
import 'package:vampir/shared/player.dart';
import 'package:vampir/shared/widgets.dart';
import 'package:vampir/home.dart';
import 'package:vampir/logic/night_logic.dart';

dynamic night(
  context,
  CollectionReference database,
  Map<String, List<String>> players,
  bool didVote,
  String votedFor,
  String sessionID,
  Player player,
) {
  DocumentSnapshot currentData = Provider.of<DocumentSnapshot>(context);

  bool inSession = false;
  bool isAdmin = false;
  bool atNight = false;
  if (currentData != null) {
    inSession = currentData.data['inSession'];
    isAdmin = currentData.data['isAdmin'];
    atNight = currentData.data['atNight'];
  }

  if (inSession && isAdmin && atNight) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text(player.role)),
      floatingActionButton: Builder(
        builder: (BuildContext context) {
          return floatingAction(
            label: 'End the Night',
            icon: Icons.arrow_forward_ios,
            onpressed: () => endNight(player, sessionID, context, database),
          );
        },
      ),
      body: ListView(
        children: [
          for (String playerID in players.keys)
            Card(
              color: Colors.deepPurple,
              child: ListTile(
                title: Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Text(players[playerID][1],
                      style: TextStyle(color: Colors.white)),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Text(players[playerID][0],
                      style: TextStyle(color: Colors.white)),
                ),
                leading: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                  child: Icon(Icons.person, color: Colors.white),
                ),
                onTap: () =>
                    vampireVote(player, didVote, playerID, database, votedFor),
              ),
            ),
        ],
      ),
    );
  } else if (inSession && !isAdmin && atNight) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text(player.role)),
      body: ListView(
        children: [
          for (String playerID in players.keys)
            Card(
              color: Colors.deepPurple,
              child: ListTile(
                title: Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Text(players[playerID][1],
                      style: TextStyle(color: Colors.white)),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Text(players[playerID][0],
                      style: TextStyle(color: Colors.white)),
                ),
                leading: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                  child: Icon(Icons.person, color: Colors.white),
                ),
                onTap: () =>
                    vampireVote(player, didVote, playerID, database, votedFor),
              ),
            ),
        ],
      ),
    );
  } else if (inSession && !atNight) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'You\'ve survived! \n\nClick to go to Day.',
            style: TextStyle(color: Colors.white, fontSize: 30),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 75),
          FlatButton(
            color: Colors.transparent,
            onPressed: () {
              Firestore.instance
                  .collection('players')
                  .document(player.email)
                  .setData({
                'atDay': true,
                'atNight': false,
              }, merge: true);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        Day(player: player, sessionID: sessionID),
                  ),
                  (route) => false);
            },
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
            'You\'ve been killed! \n\nYou will be redirected to the home page.',
            style: TextStyle(color: Colors.white, fontSize: 30),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 75),
          FlatButton(
            color: Colors.transparent,
            onPressed: () {
              Firestore.instance
                  .collection('players')
                  .document(player.email)
                  .setData({
                'atDay': false,
                'atNight': false,
                'inLobby': false,
                'isAdmin': false,
                'inSession': false,
                'role': 'villager',
              }, merge: true);
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        Home(email: player.email),
                  ),
                  (route) => false);
            },
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
