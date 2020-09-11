import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vampir/shared/player.dart';
import 'package:vampir/widgets/home_widgets/user_name.dart';
import 'package:vampir/widgets/home_widgets/bottom_sheet.dart';
import 'package:vampir/widgets/home_widgets/session_screen.dart';

class Home extends StatefulWidget {
  final String email;

  const Home({Key key, this.email}) : super(key: key);
  @override
  _HomeState createState() => _HomeState(email);
}

class _HomeState extends State<Home> {
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
  }

  @override
  void dispose() {
    sessionIDController.dispose();
    super.dispose();
  }

  _changeSessionID() {
    setState(() {
      sessionID = sessionIDController.text;
    });
  }

  Stream<DocumentSnapshot> get playerData {
    return Firestore.instance.collection('players').document(email).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> bodyWidgets = [
      UsernameScreen(
          context: context,
          playerData: playerData,
          player: player,
          email: email,
          userName: _userName),
      Builder(
        builder: (context) => SessionScreen(
            context: context,
            controller: sessionIDController,
            player: player,
            sessionID: sessionID),
      ),
    ];
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Builder(
        builder: (ctx) {
          return BottomSheetButton(
              context: ctx, player: player, vampireCount: numberOfVampires);
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
