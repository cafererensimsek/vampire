import 'package:flutter/material.dart';
import 'package:vampir/home.dart';
import 'package:vampir/shared/player.dart';

class Kicked extends StatelessWidget {
  final Player player;

  const Kicked({Key key, @required this.player}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'You\'ve been kicked out! \n\nYou will be redirected to the home page.',
            style: TextStyle(color: Colors.white, fontSize: 30),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 75),
          FlatButton(
            color: Colors.transparent,
            onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (BuildContext context) => Home(email: player.email),
                ),
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
