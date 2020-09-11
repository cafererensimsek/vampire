import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vampir/home.dart';
import 'package:vampir/shared/player.dart';

class Died extends StatelessWidget {
  final Player player;

  const Died({Key key, @required this.player}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'You\'ve been killed! \n\nYou will be redirected to the home page.',
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
                'atNight': false,
                'inLobby': false,
                'isAdmin': false,
                'inSession': false,
                'role': 'villager',
              }, merge: true);
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        Home(email: player.email),
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
