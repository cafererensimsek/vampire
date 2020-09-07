import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vampir/day.dart';
import 'package:vampir/shared/player.dart';
import 'package:vampir/shared/widgets.dart';
import 'package:vampir/home.dart';
import 'package:vampir/logic/night_logic.dart';

dynamic day(
  context,
  CollectionReference database,
  Map<String, String> players,
  bool didVote,
  String votedFor,
  String sessionID,
  Player player,
) {
  DocumentSnapshot currentData = Provider.of<DocumentSnapshot>(context);

  bool inSession = false;
  bool isAdmin = false;
  bool atDay = false;
  if (currentData != null) {
    inSession = currentData.data['inSession'];
    isAdmin = currentData.data['isAdmin'];
    atDay = currentData.data['atDay'];
  }

  if (inSession && isAdmin && atDay) {
    return Scaffold(
      backgroundColor: Colors.white,
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
              child: ListTile(
                title: Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Text(playerID),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Text(players[playerID]),
                ),
                leading: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Icon(Icons.person),
                ),
                onTap: () =>
                    vampireVote(player, didVote, playerID, database, votedFor),
              ),
            ),
        ],
      ),
    );
  } else if (inSession && !isAdmin && atDay) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text(player.role)),
      body: ListView(
        children: [
          for (String playerID in players.keys)
            Card(
              child: ListTile(
                title: Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Text(playerID),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Text(players[playerID]),
                ),
                leading: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Icon(Icons.person),
                ),
                onTap: () =>
                    vampireVote(player, didVote, playerID, database, votedFor),
              ),
            ),
        ],
      ),
    );
  } else if (inSession && !atDay) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) =>
              Day(player: player, sessionID: sessionID),
        ),
        (route) => false);
  } else if (!inSession) {
    return Scaffold(
      backgroundColor: Colors.white,
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
