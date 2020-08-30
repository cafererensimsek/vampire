import 'package:flutter/material.dart';
import 'main/auth.dart';

void main() => runApp(Vampire());

class Vampire extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vampire',
      home: Authentication(),
    );
  }
}
