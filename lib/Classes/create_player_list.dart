import 'package:cloud_firestore/cloud_firestore.dart';
import 'player.dart';

class CreateList {
  final Player admin;
  final String sessionID;

  CreateList({this.admin, this.sessionID});

  // create a username with the characters up to '@'
  // create the firestore collection for the game
  // create the first document in the collection as the admin user
  Future createCollection() async {
    final CollectionReference playerList =
        Firestore.instance.collection(sessionID);
    return admin.isAdmin
        ? await playerList.document(admin.name).setData({
            'name': admin.name,
            'isAdmin': admin.isAdmin,
            'isAlive': admin.isAlive,
            'role': admin.role,
          })
        : null;
  }
}
