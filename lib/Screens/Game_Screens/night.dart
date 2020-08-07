import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vampir/Classes/player.dart';
import 'package:vampir/Screens/loading.dart';

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

  Widget night(context, CollectionReference database, bool didVote, playerIDs) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Your role: ${player.role}')),

        // reset votes
        /* actions: [
          IconButton(
              icon: Icon(Icons.restore),
              onPressed: player.isAdmin
                  ? () {
                      database
                          .document('Game Settings')
                          .collection('Night Values')
                          .document('Villgaer Votes')
                          .delete();
                      database.getDocuments().then((snapshot) => {
                            snapshot.documents.forEach((document) {
                              document.updateData
                            })
                          });
                    }
                  : null),
        ], */
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

    List<String> playerIDs = [];
    Future<List<String>> getPlayers() async {
      QuerySnapshot docs =
          await Firestore.instance.collection(sessionID).getDocuments();
      docs.documents.forEach((element) {
        if (element.documentID != 'Game Settings') {
          playerIDs.add(element.documentID);
        }
      });

      return playerIDs;
    }

    return FutureBuilder(
      future: getPlayers(),
      builder: (context, snapshot) {
        return snapshot.hasData
            ? night(
                context,
                database,
                false,
                playerIDs,
              )
            : loading(context);
      },
    );
  }
}
