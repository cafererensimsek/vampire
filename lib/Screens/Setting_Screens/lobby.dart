// Arrange the players, assing the roles and start the game

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vampir/Screens/Game_Screens/night.dart';
import 'package:vampir/Screens/loading.dart';
import 'package:vampir/Classes/player.dart';
import 'package:provider/provider.dart';

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

  // use a snapshot from the subscribed data to create a list of current
  // players using the documentIDs
  Widget playerListDisplay(context) {
    final currentPlayers = Provider.of<QuerySnapshot>(context);
    List<String> players = [];

    currentPlayers.documents.forEach((element) {
      if (element.documentID != 'Game Settings') {
        players.add(element.documentID);
      }
    });

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        // start the game, push the admin to first night
        onPressed: player.isAdmin
            ? () {
                Firestore.instance
                    .collection(sessionID)
                    .document('Game Settings')
                    .updateData({
                  'isInLobby': false,
                });
                Navigator.push(context, MaterialPageRoute(builder: (context) => Night()));
              }
            : () {
                Firestore.instance
                    .collection(sessionID)
                    .document('Game Settings')
                    .get()
                    .then((value) => {if (value.data.containsValue(true)) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Night()));
                    } else {
                      null;
                    }});
              },
        label: Text('Start'),
        shape: RoundedRectangleBorder(),
      ),
      appBar: AppBar(
        title: Text("Session ID:$sessionID"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.shuffle),
              onPressed: player.isAdmin
                  ? () {
                      Firestore.instance
                          .collection(sessionID)
                          .getDocuments()
                          .then((snapshot) {
                        for (int i = 0;
                            i < snapshot.documents[0].data['vampireCount'];
                            i++) {
                          Firestore.instance
                              .collection(sessionID)
                              .document(snapshot
                                  .documents[(1 +
                                      Random().nextInt(
                                          snapshot.documents.length - 1))]
                                  .documentID)
                              .updateData({'role': 'vampire'});
                          print((1 +
                              Random().nextInt(snapshot.documents.length - 1)));
                        }
                      });
                    }
                  : null),
          IconButton(
              icon: Icon(Icons.restore),
              onPressed: player.isAdmin
                  ? () {
                      Firestore.instance
                          .collection(sessionID)
                          .getDocuments()
                          .then((snapshot) {
                        for (int i = 1; i < snapshot.documents.length; i++) {
                          Firestore.instance
                              .collection(sessionID)
                              .document(snapshot.documents[i].documentID)
                              .updateData({'role': 'villager'});
                        }
                      });
                    }
                  : null),
        ],
      ),
      // create a listview of the current players
      // automatically updated every time the state changes
      body: ListView(
        children: [
          for (String playerID in players)
            Card(
              child: ListTile(
                title: Padding(
                  padding: const EdgeInsets.only(left: 50),
                  child: Text(playerID),
                ),
                onTap: player.isAdmin
                    ? () {
                        Firestore.instance
                            .collection(sessionID)
                            .document(playerID)
                            .delete();
                      }
                    : null,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Icon(Icons.person),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<QuerySnapshot>.value(
      value: currentPlayers,
      child: StreamBuilder(
        stream: currentPlayers,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? playerListDisplay(context)
              : loading(context);
        },
      ),
    );
  }
}
