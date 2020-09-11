import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vampir/shared/404.dart';
import 'package:vampir/shared/died.dart';
import 'package:vampir/shared/player.dart';
import 'package:vampir/widgets/day_widgets/admin_day.dart';
import 'package:vampir/widgets/day_widgets/night_pass.dart';
import 'package:vampir/widgets/day_widgets/player_day.dart';

Widget day(
  BuildContext context,
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
  bool atDay = false;
  if (currentData != null) {
    inSession = currentData.data['inSession'];
    isAdmin = currentData.data['isAdmin'];
    atDay = currentData.data['atDay'];
  }

  if (inSession && isAdmin && atDay) {
    return AdminDay(
      player: player,
      sessionID: sessionID,
      database: database,
      votedFor: votedFor,
      players: players,
      didVote: didVote,
    );
  } else if (inSession && !isAdmin && atDay) {
    return PlayerDay(
        player: player,
        sessionID: sessionID,
        players: players,
        didVote: didVote,
        votedFor: votedFor,
        database: database);
  } else if (inSession && !atDay) {
    return NightPass(player: player, sessionID: sessionID);
  } else if (!inSession) {
    return Died(player: player);
  } else {
    return Error(player: player);
  }
}
