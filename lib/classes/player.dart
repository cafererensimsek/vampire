import 'package:flutter/material.dart';

class Player {
  String name;
  String role;
  bool isAdmin;
  bool inSession;
  String session;

  Player({
    @required this.name,
    this.isAdmin = false,
    this.role = 'villager',
    this.inSession = false,
    this.session = "",
  });
}
