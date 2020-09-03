import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vampir/classes/night_functions.dart';
import '../classes/player.dart';
import '../classes/widgets.dart';

class Night extends StatefulWidget {
  @override
  _NightState createState() => _NightState();
}

class _NightState extends State<Night> {
  Widget night(
    context,
    CollectionReference database,
    Map<String, String> players,
    bool didVote,
    String votedFor,
    String sessionID,
    Player player,
  ) {
    return Scaffold(
      floatingActionButton: Builder(
        builder: (BuildContext context) {
          return floatingAction(
            label: 'End the Night',
            icon: Icons.arrow_forward_ios,
            onpressed: () => endNight(player, sessionID, context, database),
          );
        },
      ),
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
                onTap: () =>
                    vampireVote(player, didVote, playerID, database, votedFor),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    String sessionID = arguments['sessionID'];
    Player player = arguments['player'];
    CollectionReference database = Firestore.instance.collection(sessionID);

    return FutureBuilder(
      future: getPlayers(sessionID),
      builder: (context, snapshot) {
        return snapshot.hasData
            ? night(
                context,
                database,
                snapshot.data,
                false,
                "",
                sessionID,
                player,
              )
            : loading(context);
      },
    );
  }
}
