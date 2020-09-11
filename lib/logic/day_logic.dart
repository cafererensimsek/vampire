import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vampir/day.dart';
import 'package:vampir/shared/player.dart';

String findKey(Map<String, dynamic> map, int givenValue) {
  String keyToFind;
  map.forEach((key, value) {
    if (value == givenValue) {
      keyToFind = key;
    }
  });
  return keyToFind;
}

Future<String> findvillagerChoice(sessionID) async {
  String villagerChoice;
  await Firestore.instance
      .collection(sessionID)
      .document('Game Settings')
      .collection('Night Values')
      .document('villager Votes')
      .get()
      .then((value) {
    List votes = value.data.values.toList();
    votes.sort();
    votes = votes.reversed.toList();
    votes.length > 0
        ? villagerChoice = findKey(value.data, votes[0])
        : villagerChoice = 'No choice was made!';
  });
  return villagerChoice;
}

void killVillagerChoice(sessionID, villagerChoice) {
  if (villagerChoice != 'No choice was made!') {
    Firestore.instance.collection(sessionID).document(villagerChoice).delete();
  }
  Firestore.instance
      .collection(sessionID)
      .document('Game Settings')
      .collection('Night Values')
      .document('villager Kill')
      .setData({
    'villagerKill': villagerChoice,
  });
  Firestore.instance
      .collection(sessionID)
      .document('Game Settings')
      .collection('Night Values')
      .document('villager Votes')
      .delete();
  Firestore.instance
      .collection('players')
      .document(villagerChoice)
      .setData({'inSession': false}, merge: true);
}

Future<void> setNewAdmin(sessionID, villagerKill) async {
  await Firestore.instance
      .collection(sessionID)
      .getDocuments()
      .then((snapshot) {
    String randomDocID = snapshot
        .documents[(1 + Random().nextInt(snapshot.documents.length - 1))]
        .documentID;
    if (randomDocID == villagerKill) {
      setNewAdmin(sessionID, villagerKill);
    }
    Firestore.instance
        .collection(sessionID)
        .document(randomDocID)
        .updateData({'isAdmin': true});
    Firestore.instance
        .collection('players')
        .document(randomDocID)
        .updateData({'isAdmin': true});
  });
}

void endDay(
  Player player,
  String sessionID,
  BuildContext context,
  CollectionReference database,
) async {
  var villagerChoice = await findvillagerChoice(sessionID);
  killVillagerChoice(sessionID, villagerChoice);

  await setNewAdmin(sessionID, villagerChoice);

  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) =>
            Day(player: player, sessionID: sessionID),
      ),
      (route) => false);
}

void villagerVote(
  Player player,
  bool didVote,
  String playerID,
  CollectionReference database,
  String votedFor,
) {
  if (player.role == 'villager' && !didVote && playerID != player.name) {
    database
        .document('Game Settings')
        .collection('Night Values')
        .document('villager Votes')
        .setData({
      playerID: FieldValue.increment(1),
    }, merge: true);
    didVote = true;
    votedFor = playerID;
  } else if (player.role == 'villager' &&
      didVote &&
      votedFor != playerID &&
      playerID != player.name) {
    database
        .document('Game Settings')
        .collection('Night Values')
        .document('villager Votes')
        .setData({
      votedFor: FieldValue.increment(-1),
      playerID: FieldValue.increment(1),
    }, merge: true);
    votedFor = playerID;
  }
}

Future<Map<String, List<String>>> getPlayers(String sessionID) async {
  Map<String, List<String>> players = {};
  QuerySnapshot docs =
      await Firestore.instance.collection(sessionID).getDocuments();
  docs.documents.forEach((element) {
    if (element.documentID != 'Game Settings') {
      String privilege = element.data['isAdmin'] ? 'Admin' : 'Player';
      players[element.documentID] = [privilege, element.data['name']];
    }
  });
  return players;
}
