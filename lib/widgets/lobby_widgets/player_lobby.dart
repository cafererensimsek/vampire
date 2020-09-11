import 'package:flutter/material.dart';

class PlayerLobby extends StatelessWidget {
  final String sessionID;
  final Map<String, List<String>> players;

  const PlayerLobby({Key key, @required this.sessionID, @required this.players})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Session ID:$sessionID"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: players.keys.length,
        itemBuilder: (context, index) => Card(
          color: Theme.of(context).primaryColor,
          child: ListTile(
            title: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(players[index][1],
                  style: TextStyle(color: Colors.white)),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(players[index][0],
                  style: TextStyle(color: Colors.white)),
            ),
            leading: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Icon(Icons.person, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
