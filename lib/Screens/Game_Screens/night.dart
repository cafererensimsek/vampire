import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vampir/Classes/player.dart';
import 'package:vampir/Screens/loading.dart';
import 'day.dart';
import 'package:vampir/Classes/end_night.dart';

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

  Widget night(context, CollectionReference database, List<String> playerIDs,
      bool didVote, String votedFor) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        // start the game, push the admin to first night
        onPressed: player.isAdmin
            ? () {
                var villagerChoice = EndNight(sessionID).findVillagerChoice();
                EndNight(sessionID)
                    .killVillagerChoice(sessionID, villagerChoice);
                /* var vampireChoice = EndNight(sessionID).findVampireChoice();
                EndNight(sessionID).killVampireChoice(sessionID, vampireChoice); */
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Day(
                      sessionID: sessionID,
                      player: player,
                    ),
                  ),
                );
              }
            : () {
                database.document('Game Settings').get().then((value) {
                  if (value.data['didNightEnd'] == true) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Day(
                          sessionID: sessionID,
                          player: player,
                        ),
                      ),
                    );
                  }
                });
              },
        label: Text('End the Night'),
        shape: RoundedRectangleBorder(),
      ),
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Text('It\'s Night. You are a ${player.role}'),
        ),
      ),
      // create a listview of the current players
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
                  if (player.role == 'villager' &&
                      !didVote &&
                      playerID != player.name) {
                    database
                        .document('Game Settings')
                        .collection('Night Values')
                        .document('Villager Votes')
                        .setData({
                      playerID: FieldValue.increment(1),
                    }, merge: true);
                    didVote = true;
                    votedFor = playerID;
                  } else if (player.role == 'villager' &&
                      didVote &&
                      votedFor != playerID &&
                      playerID != player.name) {
                    database
                        .document('Game Settings')
                        .collection('Night Values')
                        .document('Villager Votes')
                        .setData({
                      votedFor: FieldValue.increment(-1),
                      playerID: FieldValue.increment(1),
                    }, merge: true);
                    votedFor = playerID;
                  } else if (player.role == 'vampire' &&
                      !didVote &&
                      playerID != player.name) {
                    database
                        .document('Game Settings')
                        .collection('Night Values')
                        .document('Vampire Votes')
                        .setData({
                      playerID: FieldValue.increment(1),
                    }, merge: true);
                    didVote = true;
                    votedFor = playerID;
                  } else if (player.role == 'vampire' &&
                      didVote &&
                      votedFor != playerID &&
                      playerID != player.name) {
                    database
                        .document('Game Settings')
                        .collection('Night Values')
                        .document('Vampire Votes')
                        .setData({
                      votedFor: FieldValue.increment(-1),
                      playerID: FieldValue.increment(1),
                    }, merge: true);
                    votedFor = playerID;
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
                playerIDs,
                false,
                "",
              )
            : loading(context);
      },
    );
  }
}
