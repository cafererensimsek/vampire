import 'package:flutter/foundation.dart';

class Player {
  final String email;
  final String role;
  final bool isAdmin;
  bool isAlive;
  bool isWaiting;

  Player({
    @required this.email,
    @required this.isAlive,
    @required this.isAdmin,
    @required this.isWaiting,
    this.role,
  });
}
