import 'package:flutter/foundation.dart';

class Player {
  final String email;
  final bool isAdmin;
  bool isAlive;
  bool isWaiting;
  String role;

  Player({
    @required this.email,
    @required this.isAlive,
    @required this.isAdmin,
    @required this.isWaiting,
    @required this.role,
  });
}
