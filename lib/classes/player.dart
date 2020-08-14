import 'package:flutter/foundation.dart';

// player object
class Player {
  final String name;
  String role;
  bool isAdmin;

  Player({
    @required this.name,
    @required this.isAdmin,
    @required this.role,
  });
}
