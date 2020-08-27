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
      floatingActionButton: floatingAction(
          onpressed: () async {
            if (player.isAdmin) {
              String villagerChoice =
                  await EndNight().findVillagerChoice(sessionID);
              EndNight().killVillagerChoice(sessionID, villagerChoice);

              var vampireChoice = await EndNight().findVampireChoice(sessionID);
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
            } else {
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
                  snackbar('Wait for the admin to end the night!');
                }
              });
            }
          },
          label: 'End the Night'),
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

    Future<Map<String, String>> getPlayers() async {
      Map<String, String> players = {};
      QuerySnapshot docs =
          await Firestore.instance.collection(sessionID).getDocuments();
      docs.documents.forEach((element) {
        if (element.documentID != 'Game Settings') {
          String privilege = element.data['isAdmin'] ? 'Admin' : 'Player';
          players[element.documentID] = privilege;
        }
      });
      return players;
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
            : loading(context);
      },
    );
  }
}
