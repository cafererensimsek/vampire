// the functions that are called when the day ends
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

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
