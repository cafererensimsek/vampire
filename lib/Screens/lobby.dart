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

  void getCurrentPlayers(playerList) async {
    QuerySnapshot currentPlayers =
        await Firestore.instance.collection(sessionID).getDocuments();

    currentPlayers.documents.forEach((element) {
      playerList.add(element.documentID);
    });
  }

  Widget adminLobby() {
    List<String> playerList = [];
    getCurrentPlayers(playerList);

    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            print(playerList);
          },
          label: Text('Start the game'),
          shape: RoundedRectangleBorder(),
          icon: Icon(Icons.add),
        ),
        appBar: AppBar(
          title: Text('Session ID: $sessionID'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Text('this is rendered'),
            for (String player in playerList) ListTile(title: Text(player))
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return adminLobby();
    /* if (player.isAdmin && player.isWaiting) {
      return adminLobby();
    } else if (!player.isAdmin && player.isWaiting) {
      return loading();
    } else {
      return Text('To be added');
    } */
  }
}
