import 'package:flutter/material.dart';
import 'main/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vampire',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.redAccent,
      ),
      home: Authentication(),
    );
  }
}
