// Sign in/up and go to home page

import 'package:flutter/material.dart';
import 'main/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.blueAccent[100],
      ),
      home: Authentication(),
    );
  }
}
