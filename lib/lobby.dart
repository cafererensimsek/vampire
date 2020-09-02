import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'classes/lobby_functions.dart';
import 'classes/player.dart';
import 'classes/widgets.dart';

class Lobby extends StatefulWidget {
  final Player player;
  final String sessionID;

  const Lobby({Key key, @required this.player, @required this.sessionID})
      : super(key: key);
  @override
  _LobbyState createState() =>
      _LobbyState(player: player, sessionID: sessionID);
}

class _LobbyState extends State<Lobby> {
  final Player player;
  final String sessionID;

  _LobbyState({this.player, this.sessionID});

  Stream<QuerySnapshot> get currentPlayers {
    return Firestore.instance.collection(sessionID).snapshots();
  }

  Widget playerListDisplay(context, CollectionReference database) {
    final currentPlayers = Provider.of<QuerySnapshot>(context);
    Map<String, String> players = {};

    currentPlayers.documents.forEach((element) {
      if (element.documentID != 'Game Settings') {
        String privilege = element.data['isAdmin'] ? 'Admin' : 'Player';
        players[element.documentID] = privilege;
      }
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
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
            onPressed: player.isAdmin
                ? () => resetRoles(database, sessionID, player)
                : null,
          ),
        ],
      ),
      body: ListView(
        children: [
          for (String playerID in players.keys)
            Card(
              child: ListTile(
                title: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(playerID),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(players[playerID]),
                ),
                onTap: player.isAdmin
                    ? () {
                        database.document(playerID).delete();
                      }
                    : null,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Icon(Icons.person),
                ),
                trailing: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Icon(Icons.delete),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference database = Firestore.instance.collection(sessionID);
    return StreamProvider<QuerySnapshot>.value(
      value: currentPlayers,
      child: StreamBuilder(
        stream: currentPlayers,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? playerListDisplay(context, database)
              : loading(context);
        },
      ),
    );
  }
}
