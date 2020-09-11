import 'package:flutter/material.dart';
import 'package:vampir/logic/home_logic.dart';
import 'package:vampir/shared/player.dart';
import 'package:vampir/shared/widgets.dart';

class SessionScreen extends StatelessWidget {
  final BuildContext context;
  final TextEditingController controller;
  final Player player;
  final String sessionID;

  const SessionScreen(
      {Key key,
      @required this.context,
      @required this.controller,
      @required this.player,
      @required this.sessionID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Welcome ${player.name}',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
        SizedBox(height: 30),
        textInput(
          controller: controller,
          hintText: 'Session ID',
          keyboardType: TextInputType.number,
        ),
        FlatButton(
          child: Text(
            'Join Game',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () async =>
              await addPlayer(player, sessionID, context, player.email),
        ),
      ],
    );
  }
}
