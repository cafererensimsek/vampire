import 'package:flutter/material.dart';
import 'classes/player.dart';
import 'game/day.dart';
import 'game/night.dart';
import 'home.dart';
import 'classes/widgets.dart';

void main() => runApp(Vampire());

class Vampire extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vampire',
      theme: ThemeData(
        accentColor: Colors.white,
        primaryColor: Colors.deepPurple,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          shape: RoundedRectangleBorder(),
          backgroundColor: Colors.white,
        ),
      ),
      routes: {
        '/day': (BuildContext context) => Day(),
        '/night': (BuildContext context) => Night(),
      },
      home: Authentication(),
    );
  }
}

class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  final userNameController = TextEditingController();
  String _userName;

  @override
  void initState() {
    super.initState();
    userNameController.addListener(_changeUserName);
  }

  @override
  void dispose() {
    userNameController.dispose();
    super.dispose();
  }

  _changeUserName() {
    _userName = userNameController.text;
  }

  void createPlayer(BuildContext context) {
    Player player = new Player(name: _userName);
    _userName == null
        ? Scaffold.of(context)
            .showSnackBar(snackbar('Username must not be null!'))
        : Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => Home(player: player)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Builder(builder: (BuildContext context) {
          return Column(children: [
            SizedBox(height: 50),
            textInput(
              controller: userNameController,
              hintText: 'User Name',
            ),
            Builder(
              builder: (BuildContext context) {
                return FlatButton(
                  color: Colors.transparent,
                  child: Text(
                    'Go Home',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () => createPlayer(context),
                );
              },
            ),
          ]);
        }),
      ),
    );
  }
}
