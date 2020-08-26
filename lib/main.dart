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
        primaryColor: Colors.cyan[800],
        accentColor: Colors.deepPurple,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.white,
          elevation: 10,
          shape: RoundedRectangleBorder(),
        ),
      ),
      home: Authentication(),
    );
  }
}
