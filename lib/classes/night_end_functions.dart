// the functions that are called when the night ends
import 'package:cloud_firestore/cloud_firestore.dart';

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
