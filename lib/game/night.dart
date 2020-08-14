import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vampir/classes/night_end_functions.dart';
import '../classes/player.dart';
import '../classes/widgets.dart';
import 'day.dart';

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

  Widget night(context, CollectionReference database,
      Map<String, String> players, bool didVote, String votedFor) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: player.isAdmin
            ? () async {
                String villagerChoice =
                    await EndNight().findVillagerChoice(sessionID);
                EndNight().killVillagerChoice(sessionID, villagerChoice);

                var vampireChoice =
                    await EndNight().findVampireChoice(sessionID);
                EndNight().killVampireChoice(sessionID, vampireChoice);

                EndNight().setSettings(sessionID);

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
                  } else {
                    Widgets().snackbar('Wait for the admin to end the night!');
                  }
                });
              },
        label: Text('End the Night'),
        shape: RoundedRectangleBorder(),
      ),
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Text('It\'s Night. You are a ${player.role}.'),
        ),
      ),
      // create a listview of the current players
      body: ListView(
        children: [
          for (String playerID in players.keys)
            Card(
              child: ListTile(
                title: Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Text(playerID),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Text(players[playerID]),
                ),
                leading: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Icon(Icons.person),
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
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference database = Firestore.instance.collection(sessionID);

    Map<String, String> players = {};
    Future<void> getPlayers() async {
      QuerySnapshot docs =
          await Firestore.instance.collection(sessionID).getDocuments();
      docs.documents.forEach((element) {
        if (element.documentID != 'Game Settings') {
          String privilege = element.data['isAdmin'] ? 'Admin' : 'Player';
          players[element.documentID] = privilege;
        }
      });
    }

    return FutureBuilder(
      future: getPlayers(),
      builder: (context, snapshot) {
        return snapshot.hasData
            ? night(
                context,
                database,
                snapshot.data,
                false,
                "",
              )
            : Widgets().loading(context);
      },
    );
  }
}
