import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'player.dart';

class CreateList {
  final Player admin;
  final int sessionID;

  CreateList({this.admin, this.sessionID});

  Future createList() async {
    String userName = admin.email.substring(0, admin.email.indexOf('@'));
    final CollectionReference playerList =
        Firestore.instance.collection(sessionID.toString());
    return admin.isAdmin
        ? await playerList.document(admin.email).setData({
            'name': userName,
            'isAdmin': admin.isAdmin,
            'isAlive': admin.isAlive,
          })
        : AlertDialog(
            content: Text('User is not an admin'),
          );
  }
}
