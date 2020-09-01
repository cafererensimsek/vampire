// Arrange the players, assing the roles and start the game

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vampir/game/night.dart';
import 'classes/player.dart';
import 'classes/widgets.dart';

class Lobby extends StatefulWidget {
  final Player player;
  final String sessionID;

  const Lobby({
    Key key,
    @required this.player,
    @required this.sessionID,
  }) : super(key: key);
  @override
  _LobbyState createState() =>
      _LobbyState(player: player, sessionID: sessionID);
}

class _LobbyState extends State<Lobby> {
  final Player player;
  final String sessionID;

  _LobbyState({this.player, this.sessionID});

  // subscribe to the data stream of the collection with the sessionID
  Stream<QuerySnapshot> get currentPlayers {
    return Firestore.instance.collection(sessionID).snapshots();
  }

  // use a snapshot from the subscribed data to create a map of current
  // players using the documentIDs as keys and their privilege as values
  Widget playerListDisplay(context, CollectionReference database) {
    final currentPlayers = Provider.of<QuerySnapshot>(context);
    Map<String, String> players = {};

    currentPlayers.documents.forEach((element) {
      if (element.documentID != 'Game Settings') {
        String privilege = element.data['isAdmin'] ? 'Admin' : 'Player';
        players[element.documentID] = privilege;
      }
    });

    void startGame() {
      if (player.isAdmin) {
        database.document('Game Settings').updateData({
          'isInLobby': false,
        });
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Night(sessionID: sessionID, player: player)));
      } else {
        database.document('Game Settings').get().then(
          (value) {
            if (value.data.containsValue(false)) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Night(sessionID: sessionID, player: player)));
            } else {
              return snackbar('Wait for the admin to start the game!');
            }
          },
        );
      }
    }

    return Scaffold(
      floatingActionButton: floatingAction(
          onpressed: startGame, label: 'Start', icon: Icons.arrow_forward_ios),
      appBar: AppBar(
        title: Text("Session ID:$sessionID"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.shuffle),
            onPressed: player.isAdmin
                ? () {
                    database.getDocuments().then(
                      (snapshot) {
                        for (int i = 0;
                            i < snapshot.documents[0].data['vampireCount'];
                            i++) {
                          String randomDocID = snapshot
                              .documents[(1 +
                                  Random()
                                      .nextInt(snapshot.documents.length - 1))]
                              .documentID;
                          database
                              .document(randomDocID)
                              .updateData({'role': 'vampire'});
                          if (player.name == randomDocID) {
                            player.role = 'vampire';
                          }
                        }
                      },
                    );
                  }
                : null,
          ),
          IconButton(
            icon: Icon(Icons.restore),
            onPressed: player.isAdmin
                ? () {
                    database.getDocuments().then((snapshot) {
                      for (int i = 1; i < snapshot.documents.length; i++) {
                        Firestore.instance
                            .collection(sessionID)
                            .document(snapshot.documents[i].documentID)
                            .updateData({'role': 'villager'});
                        player.role = 'villager';
                      }
                    });
                  }
                : null,
          ),
        ],
      ),
      // create a listview of the current players
      // automatically updated every time the state changes
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
