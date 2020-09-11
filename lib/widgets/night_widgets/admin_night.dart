import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vampir/logic/night_logic.dart';
import 'package:vampir/shared/player.dart';
import 'package:vampir/shared/widgets.dart';

class AdminNight extends StatelessWidget {
  final Player player;
  final String sessionID;
  final CollectionReference database;
  final String votedFor;
  final Map<String, List<String>> players;
  final bool didVote;

  const AdminNight({
    Key key,
    @required this.player,
    @required this.sessionID,
    @required this.database,
    @required this.votedFor,
    @required this.players,
    @required this.didVote,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
  }
}
