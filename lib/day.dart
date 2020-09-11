import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vampir/logic/day_logic.dart';
import 'shared/player.dart';
import 'shared/widgets.dart';
import 'widgets/day_widgets/day_widget.dart';

class Day extends StatefulWidget {
  final Player player;
  final String sessionID;

  const Day({Key key, this.player, this.sessionID}) : super(key: key);
  @override
  _DayState createState() => _DayState(player, sessionID);
}

class _DayState extends State<Day> {
  final Player player;
  final String sessionID;

  _DayState(this.player, this.sessionID);

  Stream<DocumentSnapshot> get playerData {
    return Firestore.instance
        .collection('players')
        .document(player.email)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: playerData,
      child: FutureBuilder(
        future: getPlayers(sessionID),
        builder: (
          BuildContext context,
          AsyncSnapshot<Map<String, List<String>>> snapshot,
        ) {
          return snapshot.hasData
              ? day(
                  context,
                  Firestore.instance.collection(sessionID),
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
