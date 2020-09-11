import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vampir/shared/player.dart';
import 'package:vampir/shared/widgets.dart';
import '../lobby.dart';

Future createGame(
  Player admin,
  String sessionID,
  int vampireCount,
  BuildContext context,
  Player player,
  int numberOfVampires,
) async {
  if (numberOfVampires != null && admin.email != null) {
    await Firestore.instance
        .collection('players')
        .document(admin.email)
        .setData({
      'inSession': true,
      'isAdmin': true,
      'inLobby': true,
    }, merge: true);

    await updatePlayerOnce(player, admin.email);

    await Firestore.instance
        .collection(sessionID)
        .document(admin.email)
        .setData({
      'name': admin.name,
      'isAdmin': true,
      'role': admin.role,
    });

    Firestore.instance.collection(sessionID).document('Game Settings').setData({
      'vampireCount': vampireCount,
      'isInLobby': true,
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Lobby(
          player: player,
          sessionID: sessionID,
        ),
      ),
    );
  } else {
    Navigator.pop(context);
    Scaffold.of(context)
        .showSnackBar(snackbar('Invalid vampire count or username!'));
  }
}

Future<bool> doesExist(String sessionID) async {
  int data;
  try {
    await Firestore.instance
        .collection(sessionID)
        .document('Game Settings')
        .get()
        .then((value) => data = value.data['vampireCount']);
    return data > 0 ? true : false;
  } catch (e) {
    return false;
  }
}

Future addPlayer(
    Player player, String sessionID, BuildContext context, String email) async {
  bool check = await doesExist(sessionID);
  bool isInLobby = false;

  Firestore.instance
      .collection(sessionID)
      .document('GameSettings')
      .get()
      .then((value) => isInLobby = value.data['isInLobby']);

  if (check && player.email != null && isInLobby) {
    Firestore.instance.collection('players').document(email).setData({
      'inSession': true,
      'isAdmin': false,
      'inLobby': true,
    }, merge: true);

    await updatePlayerOnce(player, email);

    await Firestore.instance
        .collection(sessionID)
        .document(player.email)
        .setData({
      'name': player.name,
      'isAdmin': player.isAdmin,
      'role': player.role,
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Lobby(
          player: player,
          sessionID: sessionID,
        ),
      ),
    );
  } else {
    Scaffold.of(context)
        .showSnackBar(snackbar('Invalid Session ID or Username!'));
  }
}

void updatePlayerStream(Player player, BuildContext context) {
  final currentData = Provider.of<DocumentSnapshot>(context, listen: false);
  if (currentData != null && currentData.data != null) {
    player.email = currentData.data['email'];
    player.name = currentData.data['userName'];
    player.role = currentData.data['role'];
    player.inLobby = currentData.data['inLobby'];
    player.atNight = currentData.data['atNight'];
    player.atDay = currentData.data['atDay'];
    player.isAdmin = currentData.data['isAdmin'];
    player.inSession = currentData.data['inSession'];
  }
}

Future<void> updatePlayerOnce(Player player, String email) async {
  Firestore.instance.collection('players').document(email).get().then((value) {
    player.email = value.data['email'];
    player.name = value.data['userName'];
    player.role = value.data['role'];
    player.inLobby = value.data['inLobby'];
    player.atNight = value.data['atNight'];
    player.atDay = value.data['atDay'];
    player.isAdmin = value.data['isAdmin'];
    player.inSession = value.data['inSession'];
  });
}

void changeName(String userName, String email, BuildContext context) {
  if (userName == null) {
    Scaffold.of(context).showSnackBar(snackbar('Username must not be null!'));
    return;
  }
  Firestore.instance.collection('players').document(email).setData({
    'email': email,
    'userName': userName,
    'role': 'villager',
    'inLobby': false,
    'atNight': false,
    'atDay': false,
    'isAdmin': false,
    'inSession': false,
  }, merge: true);
}
