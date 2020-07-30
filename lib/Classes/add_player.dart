import 'package:cloud_firestore/cloud_firestore.dart';
import 'player.dart';

class AddPlayer {
  final Player player;
  final String sessionID;
  AddPlayer({this.player, this.sessionID});

  Future addPlayer(Player player) async {
    String userName = player.name.substring(0, player.name.indexOf('@'));
    final CollectionReference playerList =
        Firestore.instance.collection(sessionID);
    return await playerList.document(player.name).setData({
      'name': userName,
      'isAdmin': false,
      'isAlive': player.isAlive,
    });
  }
}
