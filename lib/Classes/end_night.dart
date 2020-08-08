import 'package:cloud_firestore/cloud_firestore.dart';

class EndNight {
  final String sessionID;

  EndNight(this.sessionID);

  String findKey(Map<String, dynamic> map, int givenValue) {
    String keyToFind;
    map.forEach((key, value) {
      if (value == givenValue) {
        keyToFind = key;
      }
    });
    return keyToFind;
  }

  dynamic findVillagerChoice() {
    Firestore.instance
        .collection(sessionID)
        .document('Game Settings')
        .collection('Night Values')
        .document('Villager Votes')
        .get()
        .then((value) {
      List votes = value.data.values.toList();
      votes.sort();
      votes = votes.reversed.toList();
      return votes[0] > votes[1] ? findKey(value.data, votes[0]) : false;
    });
  }

  dynamic findVampireChoice() {
    Firestore.instance
        .collection(sessionID)
        .document('Game Settings')
        .collection('Night Values')
        .document('Vamprie Votes')
        .get()
        .then((value) {
      List<int> votes = value.data.values;
      votes.sort();
      votes = votes.reversed.toList();
      return votes[0] > votes[1] ? findKey(value.data, votes[0]) : false;
    });
  }

  void killVillagerChoice(sessionID, villagerChoice) {
    if (villagerChoice != false) {
      Firestore.instance
          .collection(sessionID)
          .document(villagerChoice)
          .delete();
    }
    Firestore.instance
        .collection(sessionID)
        .document('Game Settings')
        .updateData({
      'didNightEnd': true,
    });
    Firestore.instance
        .collection(sessionID)
        .document('Game Settings')
        .collection('Night Values')
        .document('Villager Kill')
        .setData({
      'villagerKill': villagerChoice,
    });
  }

  void killVampireChoice(sessionID, vampireChoice) {
    if (vampireChoice != false) {
      Firestore.instance.collection(sessionID).document(vampireChoice).delete();
    }
    Firestore.instance
        .collection(sessionID)
        .document('Game Settings')
        .updateData({
      'didNightEnd': true,
    });
    Firestore.instance
        .collection(sessionID)
        .document('Game Settings')
        .collection('Night Values')
        .document('Villager Kill')
        .setData({
      'vampireKill': vampireChoice,
    });
  }
}
