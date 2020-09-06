import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vampir/classes/player.dart';
import 'package:vampir/classes/widgets.dart';
import 'package:vampir/logic/home_logic.dart';

void createTheGame(BuildContext context, Player player, int numberOfVampires) {
  String newSessionID = Random().nextInt(1000000).toString();
  showModalBottomSheet(
    elevation: 10,
    context: context,
    builder: (BuildContext ctx) {
      return Container(
        height: 225,
        child: Column(
          children: [
            SizedBox(height: 25),
            Text(
              'Select the Number of Vampires',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(height: 10),
            StatefulBuilder(
              builder: (BuildContext ctx, setState) {
                return Center(
                  child: DropdownButton<int>(
                    hint: Text(
                      'Number of Vampires',
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    ),
                    value: numberOfVampires,
                    icon: Icon(Icons.arrow_downward, color: Colors.black),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                    underline: Container(
                      height: 2,
                      color: Colors.black,
                    ),
                    onChanged: (int newValue) =>
                        setState(() => numberOfVampires = newValue),
                    items: <int>[1, 2, 3, 4, 5]
                        .map<DropdownMenuItem<int>>((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
            SizedBox(height: 50),
            RaisedButton(
              color: Colors.black,
              textColor: Colors.white,
              child: Text('Create'),
              onPressed: () async {
                await createGame(
                  player,
                  newSessionID,
                  numberOfVampires,
                  context,
                  player,
                  numberOfVampires,
                );
              },
            ),
          ],
        ),
      );
    },
  );
}

Widget sessionScreen(BuildContext context, TextEditingController controller,
    Player player, String sessionID) {
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

StreamProvider userName(
  BuildContext ctx,
  Stream<DocumentSnapshot> playerData,
  Player player,
  TextEditingController controller,
  String userName,
  String email,
) {
  return StreamProvider<DocumentSnapshot>.value(
    value: playerData,
    child: Consumer<DocumentSnapshot>(
      builder: (BuildContext ctx, DocumentSnapshot snapshot, child) {
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
