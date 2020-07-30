import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vampir/Classes/player.dart';

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

  List<DocumentSnapshot> joinedPlayers;

  Widget loading() {
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      body: Center(
        child: SpinKitFadingCube(
          color: Theme.of(context).primaryColor,
          size: 100.0,
        ),
      ),
    );
  }

  Widget adminLobby() {
    final CollectionReference playerList =
        Firestore.instance.collection(sessionID.toString());
    var players = playerList.getDocuments();

    print(players);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: null,
        label: Text('Start the game'),
        shape: RoundedRectangleBorder(),
        icon: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text('Session ID: $sessionID'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Text(joinedPlayers.toString()),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (player.isAdmin && player.isWaiting) {
      return adminLobby();
    } else if (!player.isAdmin && player.isWaiting) {
      return loading();
    } else {
      return Text('To be added');
    }
  }
}
