import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vampir/logic/lobby_logic.dart';
import 'package:vampir/shared/player.dart';
import 'package:vampir/shared/widgets.dart';

class AdminLobby extends StatelessWidget {
  final Player player;
  final String sessionID;
  final CollectionReference database;
  final Map<String, List<String>> players;

  const AdminLobby({
    Key key,
    @required this.player,
    @required this.sessionID,
    @required this.database,
    @required this.players,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              child: Text(players[players.keys.toList()[index]][1],
                  style: TextStyle(color: Colors.white)),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(players[players.keys.toList()[index]][0],
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
  }
}
