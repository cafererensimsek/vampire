import 'package:flutter/material.dart';

class Player {
  String name;
  String role;
  bool isAdmin;
  bool inSession;
  bool inLobby;
  bool atNight;
  bool atDay;
  String email;

  Player({
    this.email,
    @required this.name,
    this.isAdmin = false,
    this.role = 'villager',
    this.inSession = false,
    this.inLobby = false,
    this.atDay = false,
    this.atNight = false,
  });
}
