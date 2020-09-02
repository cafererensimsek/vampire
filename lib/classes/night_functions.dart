import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vampir/classes/player.dart';
import 'package:vampir/classes/widgets.dart';

String findKey(Map<String, dynamic> map, int givenValue) {
  String keyToFind;
  map.forEach((key, value) {
    if (value == givenValue) {
      keyToFind = key;
    }
  });
  return keyToFind;
}

Future<String> findVampireChoice(sessionID) async {
  String vampireChoice;
  await Firestore.instance
      .collection(sessionID)
      .document('Game Settings')
      .collection('Night Values')
      .document('Vampire Votes')
      .get()
      .then((value) {
    List votes = value.data.values.toList();
    votes.sort();
    votes = votes.reversed.toList();
    votes.length > 0
        ? vampireChoice = findKey(value.data, votes[0])
        : vampireChoice = 'No choice was made!';
  });
  return vampireChoice;
}

void killVampireChoice(sessionID, vampireChoice) {
  if (vampireChoice != 'No choice was made!') {
    Firestore.instance.collection(sessionID).document(vampireChoice).delete();
  }
  Firestore.instance
      .collection(sessionID)
      .document('Game Settings')
      .collection('Night Values')
      .document('Vampire Kill')
      .setData({
    'vampireKill': vampireChoice,
  });
  Firestore.instance
      .collection(sessionID)
      .document('Game Settings')
      .collection('Night Values')
      .document('Vampire Votes')
      .delete();
}

void setSettings(sessionID) {
  Firestore.instance
      .collection(sessionID)
      .document('Game Settings')
      .updateData({
    'didNightEnd': true,
    'didDayEnd': false,
    'isInLobby': false,
  });
}

Future<void> setNewAdmin(sessionID, vampireKill) async {
  await Firestore.instance
      .collection(sessionID)
      .getDocuments()
      .then((snapshot) {
    String randomDocID = snapshot
        .documents[(1 + Random().nextInt(snapshot.documents.length - 1))]
        .documentID;
    if (randomDocID == vampireKill) {
      setNewAdmin(sessionID, vampireKill);
    }
    Firestore.instance
        .collection(sessionID)
        .document(randomDocID)
        .updateData({'isAdmin': true});
  });
}

Future<void> setPlayerAdmin(sessionID, player) async {
  await Firestore.instance.collection(sessionID).getDocuments().then((value) {
    value.documents.forEach((element) {
      if (element.data['isAdmin'] == true &&
          element.documentID == player.name) {
        player.isAdmin = true;
      }
    });
  });
}

void endNight(Player player, String sessionID, BuildContext context,
    CollectionReference database) async {
  if (player.isAdmin) {
    var vampireChoice = await findVampireChoice(sessionID);
    killVampireChoice(sessionID, vampireChoice);

    setSettings(sessionID);
    await setNewAdmin(sessionID, vampireChoice);

    // a firebase function should run here updating each user's local data => setPlayerAdmin

    Navigator.pushNamedAndRemoveUntil(context, '/day', (route) => false,
        arguments: {'sessionID': sessionID, 'player': player});
  } else {
    database.document('Game Settings').get().then((value) {
      if (value.data['didNightEnd'] == true) {
        Navigator.pushNamedAndRemoveUntil(context, '/day', (route) => false,
            arguments: {'sessionID': sessionID, 'player': player});
      } else {
        Scaffold.of(context)
            .showSnackBar(snackbar('Wait for the admin to end the night!'));
      }
    });
  }
}

void vampireVote(Player player, bool didVote, String playerID,
    CollectionReference database, String votedFor) {
  if (player.role == 'vampire' && !didVote && playerID != player.name) {
    database
        .document('Game Settings')
        .collection('Night Values')
        .document('Vampire Votes')
        .setData({
      playerID: FieldValue.increment(1),
    }, merge: true);
    didVote = true;
    votedFor = playerID;
  } else if (player.role == 'vampire' &&
      didVote &&
      votedFor != playerID &&
      playerID != player.name) {
    database
        .document('Game Settings')
        .collection('Night Values')
        .document('Vampire Votes')
        .setData({
      votedFor: FieldValue.increment(-1),
      playerID: FieldValue.increment(1),
    }, merge: true);
    votedFor = playerID;
  }
}

Future<Map<String, String>> getPlayers(String sessionID) async {
  Map<String, String> players = {};
  QuerySnapshot docs =
      await Firestore.instance.collection(sessionID).getDocuments();
  docs.documents.forEach((element) {
    if (element.documentID != 'Game Settings') {
      String privilege = element.data['isAdmin'] ? 'Admin' : 'Player';
      players[element.documentID] = privilege;
    }
  });
  return players;
}
