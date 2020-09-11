import 'package:flutter/material.dart';
import 'package:vampir/shared/player.dart';

import '../../night.dart';

class GameTrans extends StatelessWidget {
  final List<String> vampires;
  final Player player;
  final String sessionID;

  const GameTrans(
      {Key key,
      @required this.vampires,
      @required this.player,
      @required this.sessionID})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'The game has started. \n\nClick below.',
            style: TextStyle(color: Colors.white, fontSize: 30),
            textAlign: TextAlign.center,
          ),
          if (vampires.contains(player.name))
            for (var vampire in vampires) Text(vampire),
          SizedBox(height: 75),
          FlatButton(
            color: Colors.transparent,
            onPressed: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        Night(player: player, sessionID: sessionID)),
                (route) => false),
            child: Text(
              'OK',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
        ],
      ),
    );
  }
}
