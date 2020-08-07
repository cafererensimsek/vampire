import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vampir/Classes/player.dart';

import '../loading.dart';

class Night extends StatefulWidget {
  final String sessionID;
  final Player player;

  const Night({Key key, this.sessionID, this.player}) : super(key: key);
  @override
  _NightState createState() => _NightState(sessionID, player);
}

class _NightState extends State<Night> {
  final String sessionID;
  final Player player;
  _NightState(this.sessionID, this.player);

  // subscribe to the data stream of the collection with the sessionID
  Stream<QuerySnapshot> get currentPlayers {
    return Firestore.instance.collection(sessionID).snapshots();
  }

  Widget night(context, CollectionReference database, bool didVote) {
    final currentPlayers = Provider.of<QuerySnapshot>(context);
    List<String> playerIDs = [];

    currentPlayers.documents.forEach((element) {
      if (element.documentID != 'Game Settings') {
        playerIDs.add(element.documentID);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Your role: ${player.role}')),
      ),
      // create a listview of the current players
      // automatically updated every time the state changes
      body: ListView(
        children: [
          for (String playerID in playerIDs)
            Card(
              child: ListTile(
                title: Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Text(playerID),
                ),
                onTap: () {
                  if (player.role == 'villager' && !didVote) {
                    database
                        .document('Game Settings')
                        .collection('Night Values')
                        .document('Villager Votes')
                        .setData({
                      player.name: playerID,
                    });
                    didVote = true;
                    database
                        .document(player.name)
                        .setData({'didVote': didVote}, merge: true);
                  }
                },
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
    CollectionReference database = Firestore.instance.collection(sessionID);

    bool didVote = false;

    return StreamProvider.value(
      value: currentPlayers,
      child: StreamBuilder(
          stream: currentPlayers,
          builder: (context, snapshot) {
            return snapshot.hasData
                ? night(context, database, didVote)
                : loading(context);
          }),
    );
  }
}
