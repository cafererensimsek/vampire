import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vampir/Classes/player.dart';

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
    List<String> playerIDs = [];

    Firestore.instance.collection(sessionID).getDocuments().then(
          (value) => value.documents.forEach((element) {
            playerIDs.add(element.documentID);
          }),
        );

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

    return night(context, database, false);
  }
}
