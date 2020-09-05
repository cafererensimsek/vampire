// the functions that are called when the day ends
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

void setSettings(sessionID) {
  Firestore.instance
      .collection(sessionID)
      .document('Game Settings')
      .updateData({
    'didDayEnd': true,
    'didNightEnd': false,
  });
  Firestore.instance
      .collection(sessionID)
      .document('Game Settings')
      .collection('Day Values')
      .document('Villager Kill')
      .delete();
}

Future<String> findVillagerChoice(sessionID) async {
  String villagerChoice;
  await Firestore.instance
      .collection(sessionID)
      .document('Game Settings')
      .collection('Day Values')
      .document('Villager Votes')
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
      .collection('Day Values')
      .document('Villager Kill')
      .setData({
    'vampireKill': villagerChoice,
  });
  Firestore.instance
      .collection(sessionID)
      .document('Game Settings')
      .collection('Day Values')
      .document('Villager Votes')
      .delete();
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

void endDay(Player player, String sessionID, String villagerKill,
    BuildContext context) {
  if (player.isAdmin) {
    setSettings(sessionID);
    if (player.name == villagerKill) {
      setNewAdmin(sessionID, villagerKill);
/*       Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Home(player: player),
        ),
      ); */
    } else {
      Navigator.pushNamedAndRemoveUntil(context, '/night', (route) => false,
          arguments: {'sessionID': sessionID, 'player': player});
    }
  } else {
    Firestore.instance
        .collection(sessionID)
        .document('Game Settings')
        .get()
        .then((value) {
      if (value.data['didDayEnd'] == true) {
        if (player.name != villagerKill) {
          setPlayerAdmin(sessionID, player);
          Navigator.pushNamedAndRemoveUntil(context, '/night', (route) => false,
              arguments: {'sessionID': sessionID, 'player': player});
        } else {
          Navigator.pushNamedAndRemoveUntil(context, '/night', (route) => false,
              arguments: {'sessionID': sessionID, 'player': player});
        }
      } else {
        snackbar('Wait for admin to end the night!');
      }
    });
  }
}
