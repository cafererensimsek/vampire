// the functions that handle game creation and join
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vampir/classes/player.dart';
import 'package:vampir/classes/widgets.dart';

Future createGame(Player admin, String sessionID) async {
  admin.isAdmin = true;
  await Firestore.instance.collection(sessionID).document(admin.name).setData({
    'name': admin.name,
    'isAdmin': admin.isAdmin,
    'role': admin.role,
  });
}

Future addPlayer(Player player, String sessionID) async {
  return await Firestore.instance
      .collection(sessionID)
      .document(player.name)
      .setData({
    'name': player.name,
    'isAdmin': player.isAdmin,
    'role': player.role,
  });
}

void startGame(CollectionReference database, Player player,
    BuildContext context, String sessionID) {
  if (player.isAdmin) {
    database.document('Game Settings').updateData({
      'isInLobby': false,
    });
    Navigator.pushNamedAndRemoveUntil(context, '/night', (route) => false,
        arguments: {'sessionID': sessionID, 'player': player});
  } else {
    database.document('Game Settings').get().then(
      (value) {
        if (value.data.containsValue(false)) {
          Navigator.pushNamedAndRemoveUntil(context, '/night', (route) => false,
              arguments: {'sessionID': sessionID, 'player': player});
        } else {
          return Scaffold.of(context)
              .showSnackBar(snackbar('Wait for the admin to start the game!'));
        }
      },
    );
  }
}

void resetRoles(CollectionReference database, String sessionID, Player player) {
  database.getDocuments().then((snapshot) {
    for (int i = 1; i < snapshot.documents.length; i++) {
      database
          .document(snapshot.documents[i].documentID)
          .updateData({'role': 'villager'});
      player.role = 'villager';
    }
  });
}

void assignRoles(CollectionReference database, Player player) {
  database.getDocuments().then(
    (snapshot) {
      for (int i = 0; i < snapshot.documents[0].data['vampireCount']; i++) {
        String randomDocID = snapshot
            .documents[(1 + Random().nextInt(snapshot.documents.length - 1))]
            .documentID;
        database.document(randomDocID).updateData({'role': 'vampire'});
        if (player.name == randomDocID) {
          player.role = 'vampire';
        }
      }
    },
  );
}
