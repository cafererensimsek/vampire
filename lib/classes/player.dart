import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Player {
  String name;
  String role;
  bool isAdmin;
  bool inSession;
  String session;
  String email;

  Player({
    this.email,
    @required this.name,
    this.isAdmin = false,
    this.role = 'villager',
    this.inSession = false,
    this.session = "",
  });
}
