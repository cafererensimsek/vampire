import 'package:flutter/foundation.dart';

class Player {
  final String email;
  final bool isAdmin;
  final String name;
  bool isAlive;
  String role;

  Player({
    @required this.name,
    @required this.email,
    @required this.isAlive,
    @required this.isAdmin,
    @required this.role,
  });
}
