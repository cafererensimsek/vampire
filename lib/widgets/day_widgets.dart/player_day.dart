import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vampir/logic/night_logic.dart';
import 'package:vampir/shared/player.dart';

class PlayerDay extends StatelessWidget {
  final Player player;
  final String sessionID;
  final Map<String, List<String>> players;
  final bool didVote;
  final String votedFor;
  final CollectionReference database;

  const PlayerDay({
    Key key,
    @required this.player,
    @required this.sessionID,
    @required this.players,
    @required this.didVote,
    @required this.votedFor,
    @required this.database,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
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
                  child: Text(players[playerID][1]),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Text(players[playerID][0]),
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
  }
}
