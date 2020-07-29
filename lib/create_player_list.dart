import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'player.dart';

class CreateList {
  final Player admin;
  final int sessionID;

  CreateList({this.admin, this.sessionID});

  final CollectionReference playerList = Firestore.instance.collection('games');

  Future createList() async {
    return admin.isAdmin
        ? await playerList.document(sessionID.toString()).setData({
            'name': admin.name,
            'isAdmin': admin.isAdmin,
            'isAlive': admin.isAlive,
          })
        : AlertDialog(
            content: Text('Session already exists, try again!'),
          );
  }
}
