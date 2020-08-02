import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vampir/Screens/loading.dart';
import 'package:vampir/Classes/player.dart';
import 'package:provider/provider.dart';
import 'package:vampir/Screens/night.dart';

class Lobby extends StatefulWidget {
  final Player player;
  final String sessionID;

  const Lobby({Key key, this.player, this.sessionID}) : super(key: key);
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

  Widget playerListDisplay(context) {
    final currentPlayers = Provider.of<QuerySnapshot>(context);
    List<String> players = [];

    currentPlayers.documents.forEach((element) {
      players.add(element.documentID);
    });

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: player.isAdmin
            ? () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Night()));
              }
            : null,
        label: Text('Start'),
        shape: RoundedRectangleBorder(),
      ),
      appBar: AppBar(
        title: Text("Session ID:$sessionID"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 50),
          ListView(
            children: [
              for (String player in players)
                Card(child: ListTile(title: Text(player))),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<QuerySnapshot>.value(
        value: currentPlayers,
        child: StreamBuilder(
          stream: currentPlayers,
          builder: (context, snapshot) {
            return snapshot.hasData
                ? playerListDisplay(context)
                : loading(context);
          },
        ));
  }
}
