import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vampir/night.dart';
import 'package:vampir/shared/player.dart';

class NightPass extends StatelessWidget {
  final Player player;
  final String sessionID;

  const NightPass({Key key, @required this.player, @required this.sessionID})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'You\'ve survived! \n\nClick to go to Night.',
            style: TextStyle(color: Colors.white, fontSize: 30),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 75),
          FlatButton(
            color: Colors.transparent,
            onPressed: () {
              Firestore.instance
                  .collection('players')
                  .document(player.email)
                  .setData({
                'atDay': false,
                'atNight': true,
              }, merge: true);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        Night(player: player, sessionID: sessionID),
                  ),
                  (route) => false);
            },
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
