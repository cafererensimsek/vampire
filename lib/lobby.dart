import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vampir/widgets/lobby_widgets/lobby_widget.dart';
import 'shared/player.dart';

class Lobby extends StatefulWidget {
  final Player player;
  final String sessionID;

  const Lobby({Key key, @required this.player, @required this.sessionID})
      : super(key: key);
  @override
  _LobbyState createState() =>
      _LobbyState(player: player, sessionID: sessionID);
}

class _LobbyState extends State<Lobby> {
  final Player player;
  final String sessionID;

  _LobbyState({this.player, this.sessionID});

  Stream<QuerySnapshot> get currentPlayers {
    return Firestore.instance.collection(sessionID).snapshots();
  }

  Stream<DocumentSnapshot> get playerData {
    return Firestore.instance
        .collection('players')
        .document(player.email)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<QuerySnapshot>.value(value: currentPlayers),
        StreamProvider<DocumentSnapshot>.value(value: playerData),
      ],
      child: Builder(
        builder: (context) => playerListDisplay(
          context,
          Firestore.instance.collection(sessionID),
          player,
          sessionID,
        ),
      ),
    );
  }
}
