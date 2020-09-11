import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vampir/shared/404.dart';
import 'package:vampir/shared/player.dart';
import 'package:vampir/logic/lobby_logic.dart';
import 'package:vampir/widgets/lobby_widgets/admin_lobby.dart';
import 'package:vampir/widgets/lobby_widgets/game_transition.dart';
import 'package:vampir/widgets/lobby_widgets/kicked_out.dart';
import 'package:vampir/widgets/lobby_widgets/player_lobby.dart';

dynamic playerListDisplay(
  BuildContext context,
  CollectionReference database,
  Player player,
  String sessionID,
) {
  DocumentSnapshot currentData = Provider.of<DocumentSnapshot>(context);
  Map<String, List<String>> players = getCurrentPlayers(context);
  List<String> vampires;

  players.forEach((key, value) {
    if (players[key][2] == 'vampire') {
      vampires.add(players[key][1]);
    }
  });

  bool inSession = false;
  bool isAdmin = false;
  bool inLobby = true;
  bool atNight = false;

  if (currentData != null) {
    inSession = currentData.data['inSession'];
    isAdmin = currentData.data['isAdmin'];
    inLobby = currentData.data['inLobby'];
    atNight = currentData.data['atNight'];
    player.role = currentData['role'];
  }

  if (inSession && isAdmin && inLobby) {
    return AdminLobby(
        player: player,
        sessionID: sessionID,
        database: database,
        players: players);
  } else if (inSession && !isAdmin && inLobby) {
    return PlayerLobby(sessionID: sessionID, players: players);
  } else if (inSession && !isAdmin && atNight) {
    return GameTrans(vampires: vampires, player: player, sessionID: sessionID);
  } else if (!inSession) {
    return Kicked(player: player);
  } else {
    Error(player: player);
  }
}
