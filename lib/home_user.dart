import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vampir/classes/player.dart';
import 'classes/widgets.dart';

class HomeUser extends StatefulWidget {
  final FirebaseUser user;

  const HomeUser({Key key, this.user}) : super(key: key);
  @override
  _HomeUserState createState() => _HomeUserState(user);
}

class _HomeUserState extends State<HomeUser> {
  final FirebaseUser user;
  final userNameController = TextEditingController();
  String _userName;
  Player player = Player(name: "Player");

  _HomeUserState(this.user);

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

  Stream<DocumentSnapshot> get playerData {
    return Firestore.instance
        .collection('players')
        .document(user.email)
        .snapshots();
  }

  void record() {
    if (_userName == null) {
      Scaffold.of(context).showSnackBar(snackbar('Username must not be null!'));
      return;
    }
    Firestore.instance.collection('players').document(user.email).setData({
      'userName': _userName,
      'role': 'villager',
      'session': "",
      'isAdmin': false,
      'inSession': false,
    }, merge: true);
  }

  void updatePlayer(BuildContext ctx) {
    final currentData = Provider.of<DocumentSnapshot>(ctx);
    if (currentData.data != null) {
      player.name = currentData.data['userName'];
      player.role = currentData.data['role'];
      player.session = currentData.data['session'];
      player.isAdmin = currentData.data['isAdmin'];
      player.inSession = currentData.data['inSession'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<DocumentSnapshot>.value(
      value: playerData,
      child: StreamBuilder(
        stream: playerData,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          updatePlayer(context);
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Choose Your Nick',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
              SizedBox(height: 30),
              textInput(controller: userNameController),
              FlatButton(
                child: Text(
                  'Change',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: record,
              ),
              SizedBox(height: 30),
              Text(
                'Current nick: ${player.name}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
