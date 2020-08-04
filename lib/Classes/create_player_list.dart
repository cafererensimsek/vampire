import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'player.dart';

class CreateList {
  final Player admin;
  final String sessionID;

  CreateList({this.admin, this.sessionID});

  // create a username with the characters up to '@'
  // create the firestore collection for the game
  // create the first document in the collection as the admin user
  Future createCollection() async {
    String userName = admin.email.substring(0, admin.email.indexOf('@'));
    final CollectionReference playerList =
        Firestore.instance.collection(sessionID);
    return admin.isAdmin
        ? await playerList.document(userName).setData({
            'name': userName,
            'isAdmin': admin.isAdmin,
            'isAlive': admin.isAlive,
            'role': admin.role,
          })
        : AlertDialog(
            content: Text('User is not an admin'),
          );
  }
}
