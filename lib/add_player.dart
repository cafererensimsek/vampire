import 'package:cloud_firestore/cloud_firestore.dart';
import 'player.dart';

class AddPlayer {
  final Player player;
  AddPlayer(this.player);

  final CollectionReference playerList =
      Firestore.instance.collection('players');

  Future addPlayer(Player player) async {
    return await playerList.document(player.name).setData({
      'name': player.name,
      'isAdmin': player.isAdmin,
      'isAlive': player.isAlive,
    });
  }
}
