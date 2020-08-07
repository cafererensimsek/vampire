import 'package:cloud_firestore/cloud_firestore.dart';
import 'player.dart';

class AddPlayer {
  final Player player;
  final String sessionID;
  AddPlayer({this.player, this.sessionID});

  // create and add a non-admin user to the given sessionID
  Future addPlayer(Player player) async {
    final CollectionReference playerList =
        Firestore.instance.collection(sessionID);
    return await playerList.document(player.name).setData({
      'name': player.name,
      'isAdmin': player.isAdmin,
      'isAlive': player.isAlive,
      'role': player.role,
    });
  }
}
