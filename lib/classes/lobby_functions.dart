// the functions that handle game creation and join
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vampir/classes/player.dart';
import 'package:vampir/classes/widgets.dart';

class HandleLobby {
  Future createGame(Player admin, String sessionID) async {
    return admin.isAdmin
        ? await Firestore.instance
            .collection(sessionID)
            .document(admin.name)
            .setData({
            'name': admin.name,
            'isAdmin': admin.isAdmin,
            'role': admin.role,
          })
        : null;
  }

  Future addPlayer(Player player, String sessionID) async {
    bool exists;
    await Firestore.instance.collection(sessionID).getDocuments().then(
        (snapshot) =>
            snapshot.documents.length != 0 ? exists = true : exists = false);

    return exists
        ? await Firestore.instance
            .collection(sessionID)
            .document(player.name)
            .setData({
            'name': player.name,
            'isAdmin': player.isAdmin,
            'role': player.role,
          })
        : Widgets().snackbar('The game doesn\'t exist!');
  }
}
