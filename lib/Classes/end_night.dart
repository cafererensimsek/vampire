import 'package:cloud_firestore/cloud_firestore.dart';

class EndNight {
  final String sessionID;

  EndNight(this.sessionID);

  dynamic findVillagerChoice() {
    Firestore.instance
        .collection('sessionID')
        .document('Game Settings')
        .collection('Night Values')
        .document('Villager Votes')
        .get()
        .then((value) {
      List<int> votes = value.data.values;
      votes.sort();
      votes = votes.reversed.toList();
      if (votes[0] == votes[1]) {
        return false;
      } else {
        value.data.forEach((key, value) {
          if (value == votes[0]) {
            return key;
          }
        });
      }
    });
  }

  dynamic findVampireChoice() {
    Firestore.instance
        .collection('sessionID')
        .document('Game Settings')
        .collection('Night Values')
        .document('Vamprie Votes')
        .get()
        .then((value) {
      List<int> votes = value.data.values;
      votes.sort();
      votes = votes.reversed.toList();
      if (votes[0] == votes[1]) {
        return false;
      } else {
        value.data.forEach((key, value) {
          if (value == votes[0]) {
            return key;
          }
        });
      }
    });
  }

  void killVillagerChoice(sessionID) {
    if (findVillagerChoice() != false) {
      Firestore.instance
          .collection(sessionID)
          .document(findVillagerChoice())
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
        .updateData({
      'villagerKill': findVillagerChoice(),
    });
  }

  void killVampireChoice(sessionID) {
    if (findVampireChoice() != false) {
      Firestore.instance
          .collection(sessionID)
          .document(findVampireChoice())
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
        .updateData({
      'vampireKill': findVampireChoice(),
    });
  }
}
