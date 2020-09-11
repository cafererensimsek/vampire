import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vampir/shared/404.dart';
import 'package:vampir/shared/player.dart';
import 'package:vampir/widgets/night_widgets/admin_night.dart';
import 'package:vampir/widgets/night_widgets/day_pass.dart';
import 'package:vampir/shared/died.dart';
import 'package:vampir/widgets/night_widgets/player_night.dart';

Widget night(
  context,
  CollectionReference database,
  Map<String, List<String>> players,
  bool didVote,
  String votedFor,
  String sessionID,
  Player player,
) {
  DocumentSnapshot currentData = Provider.of<DocumentSnapshot>(context);

  bool inSession = false;
  bool isAdmin = false;
  bool atNight = false;
  if (currentData != null) {
    inSession = currentData.data['inSession'];
    isAdmin = currentData.data['isAdmin'];
    atNight = currentData.data['atNight'];
  }

  if (inSession && isAdmin && atNight) {
    return AdminNight(
      player: player,
      sessionID: sessionID,
      database: database,
      votedFor: votedFor,
      players: players,
      didVote: didVote,
    );
  } else if (inSession && !isAdmin && atNight) {
    return PlayerNight(
      player: player,
      sessionID: sessionID,
      players: players,
      didVote: didVote,
      votedFor: votedFor,
      database: database,
    );
  } else if (inSession && !atNight) {
    return DayPass(player: player, sessionID: sessionID);
  } else if (!inSession) {
    return Died(player: player);
  } else {
    return Error(player: player);
  }
}
