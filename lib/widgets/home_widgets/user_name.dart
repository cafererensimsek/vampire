import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vampir/logic/home_logic.dart';
import 'package:vampir/shared/player.dart';
import 'package:vampir/shared/widgets.dart';

class UsernameScreen extends StatefulWidget {
  final BuildContext context;
  final Stream<DocumentSnapshot> playerData;
  final Player player;
  final TextEditingController controller;
  final String userName;
  final String email;

  const UsernameScreen(
      {Key key,
      @required this.context,
      @required this.playerData,
      @required this.player,
      @required this.controller,
      @required this.userName,
      this.email})
      : super(key: key);
  @override
  _UsernameScreenState createState() => _UsernameScreenState(
      context, playerData, player, controller, userName, email);
}

class _UsernameScreenState extends State<UsernameScreen> {
  final BuildContext context;
  final Stream<DocumentSnapshot> playerData;
  final Player player;
  final TextEditingController controller;
  final String userName;
  final String email;

  _UsernameScreenState(this.context, this.playerData, this.player,
      this.controller, this.userName, this.email);
  @override
  Widget build(BuildContext context) {
    return StreamProvider<DocumentSnapshot>.value(
      value: playerData,
      child: Consumer<DocumentSnapshot>(
        builder: (ctx, snapshot, _) {
          updatePlayerStream(player, ctx);
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Choose Your Name ${player.name}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
              SizedBox(height: 30),
              textInput(controller: controller),
              FlatButton(
                child: Text(
                  'Change',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () => changeName(userName, email, ctx),
              ),
              SizedBox(height: 30),
            ],
          );
        },
      ),
    );
  }
}
