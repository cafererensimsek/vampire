import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vampir/logic/night_logic.dart';
import 'shared/player.dart';
import 'shared/widgets.dart';
import 'widgets/night_widgets/night_widget.dart';

class Night extends StatefulWidget {
  final Player player;
  final String sessionID;

  const Night({Key key, this.player, this.sessionID}) : super(key: key);
  @override
  _NightState createState() => _NightState(player, sessionID);
}

class _NightState extends State<Night> {
  final Player player;
  final String sessionID;

  _NightState(this.player, this.sessionID);

  Stream<DocumentSnapshot> get playerData {
    return Firestore.instance
        .collection('players')
        .document(player.email)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference database = Firestore.instance.collection(sessionID);

    return StreamProvider.value(
      value: playerData,
      child: FutureBuilder(
        future: getPlayers(sessionID),
        builder: (
          BuildContext context,
          AsyncSnapshot<Map<String, List<String>>> snapshot,
        ) {
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
      ),
    );
  }
}
