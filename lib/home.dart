import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vampir/classes/player.dart';
import 'package:vampir/widgets/home_widget.dart';

class Home extends StatefulWidget {
  final String email;

  const Home({Key key, this.email}) : super(key: key);
  @override
  _HomeState createState() => _HomeState(email);
}

class _HomeState extends State<Home> {
  final userNameController = TextEditingController();
  final sessionIDController = TextEditingController();
  final String email;
  String sessionID;
  int numberOfVampires;
  int _index = 0;

  String _userName;
  Player player = Player(name: "Player");

  _HomeState(this.email);

  @override
  void initState() {
    super.initState();
    sessionIDController.addListener(_changeSessionID);
    userNameController.addListener(_changeUserName);
  }

  @override
  void dispose() {
    sessionIDController.dispose();
    userNameController.dispose();
    super.dispose();
  }

  _changeSessionID() {
    setState(() {
      sessionID = sessionIDController.text;
    });
  }

  _changeUserName() {
    setState(() {
      _userName = userNameController.text;
    });
  }

  Stream<DocumentSnapshot> get playerData {
    return Firestore.instance.collection('players').document(email).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> bodyWidgets = [
      userName(
          context, playerData, player, userNameController, _userName, email),
      Builder(
          builder: (BuildContext context) =>
              sessionScreen(context, sessionIDController, player, sessionID)),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Builder(
        builder: (BuildContext ctx) {
          return FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () => createTheGame(ctx, player, numberOfVampires),
          );
        },
      ),
      body: bodyWidgets[_index],
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () => setState(() => _index = 0),
            ),
            IconButton(
              icon: Icon(Icons.play_arrow),
              onPressed: () => setState(() => _index = 1),
            ),
          ],
        ),
      ),
    );
  }
}
