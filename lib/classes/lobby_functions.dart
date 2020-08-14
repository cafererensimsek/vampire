// the functions that handle game creation and join
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vampir/classes/player.dart';

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
