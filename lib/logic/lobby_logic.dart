import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vampir/shared/player.dart';

import '../night.dart';

void startGame(
  CollectionReference database,
  Player player,
  BuildContext context,
  String sessionID,
) {
  database.document('Game Settings').updateData({
    'isInLobby': false,
  });
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) =>
              Night(player: player, sessionID: sessionID)),
      (route) => false);

  database.getDocuments().then((snapshot) {
    snapshot.documents.forEach((document) {
      print(document.documentID);
      if (document.documentID != 'Game Settings') {
        Firestore.instance
            .collection('players')
            .document(document.documentID)
            .setData({
          'inLobby': false,
          'atNight': true,
        }, merge: true);
      }
    });
  });
}

void resetRoles(CollectionReference database, String sessionID, Player player) {
  if (player.isAdmin) {
    database.getDocuments().then((snapshot) {
      for (int i = 1; i < snapshot.documents.length; i++) {
        database
            .document(snapshot.documents[i].documentID)
            .updateData({'role': 'villager'});
        player.role = 'villager';
      }
    });
  }
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

Map getCurrentPlayers(BuildContext context) {
  final currentPlayers = Provider.of<QuerySnapshot>(context);
  Map<String, List<String>> players = {};

  currentPlayers.documents.forEach((element) {
    if (element.documentID != 'Game Settings') {
      String privilege = element.data['isAdmin'] ? 'Admin' : 'Player';
      players[element.documentID] = [privilege, element.data['name']];
    }
  });

  return players;
}

void deletePlayer(
  CollectionReference database,
  String playerID,
  Player player,
) {
  if (player.isAdmin) {
    database.document(playerID).delete();
    Firestore.instance.collection('players').document(playerID).setData({
      'inSession': false,
    }, merge: true);
  }
}
