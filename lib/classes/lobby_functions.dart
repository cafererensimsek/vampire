// the functions that handle game creation and join
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vampir/classes/player.dart';

Future createGame(Player admin, String sessionID) async {
  admin.isAdmin = true;
  await Firestore.instance.collection(sessionID).document(admin.name).setData({
    'name': admin.name,
    'isAdmin': admin.isAdmin,
    'role': admin.role,
  });
}

Future addPlayer(Player player, String sessionID) async {
  return await Firestore.instance
      .collection(sessionID)
      .document(player.name)
      .setData({
    'name': player.name,
    'isAdmin': player.isAdmin,
    'role': player.role,
  });
}
