import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vampir/Screens/loading.dart';
import 'package:vampir/Classes/player.dart';
import 'package:provider/provider.dart';
import 'package:vampir/Screens/night.dart';

class Lobby extends StatefulWidget {
  final Player player;
  final String sessionID;
  final int vampireCount;

  const Lobby(
      {Key key,
      @required this.player,
      @required this.sessionID,
      this.vampireCount})
      : super(key: key);
  @override
  _LobbyState createState() => _LobbyState(
      player: player, sessionID: sessionID, vampireCount: vampireCount);
}

class _LobbyState extends State<Lobby> {
  final Player player;
  final String sessionID;
  final int vampireCount;
  _LobbyState({this.player, this.sessionID, this.vampireCount});

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
      players.add(element.documentID);
    });

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        // start the game, push the admin to first night
        onPressed: player.isAdmin
            ? () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Night()));
              }
            : null,
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
                      for (int i = 0; i < 2; i++) {
                        Firestore.instance
                            .collection(sessionID)
                            .document(snapshot
                                .documents[
                                    Random().nextInt(snapshot.documents.length)]
                                .documentID)
                            .updateData({'role': 'vampire'});
                      }
                    });
                  }
                : null,
          ),
          IconButton(
            icon: Icon(Icons.restore),
            onPressed: player.isAdmin
                ? () {
                    Firestore.instance
                        .collection(sessionID)
                        .getDocuments()
                        .then((snapshot) {
                      for (int i = 0; i < snapshot.documents.length; i++) {
                        Firestore.instance
                            .collection(sessionID)
                            .document(snapshot.documents[i].documentID)
                            .updateData({'role': 'villager'});
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
          for (String playerID in players)
            Card(
              child: ListTile(
                title: Text(playerID),
                onTap: player.isAdmin
                    ? () {
                        Firestore.instance
                            .collection(sessionID)
                            .document(playerID)
                            .delete();
                      }
                    : null,
                leading: Icon(Icons.person),
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
