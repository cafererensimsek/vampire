import 'package:flutter/foundation.dart';

class Player {
  final String name;
  final String role;
  final bool isAlive;
  final bool isAdmin;

  Player({
    @required this.name,
    this.role,
    @required this.isAlive,
    @required this.isAdmin,
  });
}
