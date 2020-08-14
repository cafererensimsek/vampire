import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'dart:math';

// player object
class Player {
  final String email;
  final bool isAdmin;
  final String name;
  bool isAlive;
  String role;

  Player({
    @required this.name,
    @required this.email,
    @required this.isAlive,
    @required this.isAdmin,
    @required this.role,
  });
}

// the functions that handle game creation and join
class HandleLobby {
  Future createGame(Player admin, String sessionID) async {
    return admin.isAdmin
        ? await Firestore.instance
            .collection(sessionID)
            .document(admin.name)
            .setData({
            'name': admin.name,
            'isAdmin': admin.isAdmin,
            'isAlive': admin.isAlive,
            'role': admin.role,
          })
        : null;
  }

  Future addPlayer(Player player, String sessionID) async {
    return await Firestore.instance
        .collection(sessionID)
        .document(player.name)
        .setData({
      'name': player.name,
      'isAdmin': player.isAdmin,
      'isAlive': player.isAlive,
      'role': player.role,
    });
  }
}

// the functions that are called when the day ends
class EndDay {
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
        .collection('Night Values')
        .document('Vampire Kill')
        .delete();
    Firestore.instance
        .collection(sessionID)
        .document('Game Settings')
        .collection('Night Values')
        .document('Villager Kill')
        .delete();
  }

  Future<void> setNewAdmin(sessionID) async {
    await Firestore.instance
        .collection(sessionID)
        .getDocuments()
        .then((snapshot) {
      for (int i = 0; i < snapshot.documents[0].data['vampireCount']; i++) {
        String randomDocID = snapshot
            .documents[(1 + Random().nextInt(snapshot.documents.length - 1))]
            .documentID;
        Firestore.instance
            .collection(sessionID)
            .document(randomDocID)
            .updateData({'isAdmin': true});
      }
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
}

// the functions that are called when the night ends
class EndNight {
  String findKey(Map<String, dynamic> map, int givenValue) {
    String keyToFind;
    map.forEach((key, value) {
      if (value == givenValue) {
        keyToFind = key;
      }
    });
    return keyToFind;
  }

  Future<String> findVillagerChoice(sessionID) async {
    String villagerChoice;
    await Firestore.instance
        .collection(sessionID)
        .document('Game Settings')
        .collection('Night Values')
        .document('Villager Votes')
        .get()
        .then((value) {
      List votes = value.data.values.toList();
      votes.sort();
      votes = votes.reversed.toList();
      votes.length > 0
          ? villagerChoice = findKey(value.data, votes[0])
          : villagerChoice = 'No choice was made!';
      print(villagerChoice);
    });
    return villagerChoice;
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

  void killVillagerChoice(sessionID, villagerChoice) {
    if (villagerChoice != 'No choice was made!') {
      Firestore.instance
          .collection(sessionID)
          .document(villagerChoice)
          .delete();
    }
    Firestore.instance
        .collection(sessionID)
        .document('Game Settings')
        .collection('Night Values')
        .document('Villager Kill')
        .setData({
      'villagerKill': villagerChoice,
    });
    Firestore.instance
        .collection(sessionID)
        .document('Game Settings')
        .collection('Night Values')
        .document('Villager Votes')
        .delete();
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
      'isInLobby': true,
    });
  }
}
