import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vampir/classes/player.dart';
import 'package:vampir/classes/widgets.dart';
import 'home.dart';

class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String email;
  String password;

  @override
  void initState() {
    super.initState();
    emailController.addListener(_changeEmail);
    passwordController.addListener(_changePassword);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  _changeEmail() {
    email = emailController.text;
  }

  _changePassword() {
    password = passwordController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        TextField(
          controller: emailController,
          decoration:
              InputDecoration(hintText: 'Email', icon: Icon(Icons.mail)),
        ),
        SizedBox(height: 20),
        TextField(
          controller: passwordController,
          obscureText: true,
          decoration: InputDecoration(
            icon: Icon(Icons.vpn_key),
            hintText: 'Password',
          ),
        ),
        SizedBox(height: 20),
        FlatButton(
          onPressed: () async {
            try {
              FirebaseUser user = (await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: email, password: password))
                  .user;
              Player player = new Player(
                  name: user.email.substring(0, user.email.indexOf('@')),
                  isAdmin: true,
                  role: 'villager');
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Home(player: player)));
            } catch (e) {
              switch (e.code) {
                case "ERROR_USER_NOT_FOUND":
                  if (password.length >= 6) {
                    try {
                      FirebaseUser user = (await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: email, password: password))
                          .user;
                      Player player = new Player(
                          name:
                              user.email.substring(0, user.email.indexOf('@')),
                          isAdmin: true,
                          role: 'villager');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Home(player: player)));
                    } catch (e) {
                      Scaffold.of(context)
                          .showSnackBar(Widgets().snackbar(e.message));
                    }
                  } else {
                    Scaffold.of(context).showSnackBar(Widgets()
                        .snackbar('Password must be at least 6 characters!'));
                  }
                  break;
                default:
                  Scaffold.of(context)
                      .showSnackBar(Widgets().snackbar(e.message));
                  break;
              }
            }
          },
          color: Theme.of(context).accentColor,
          child: Text('Sign In/Sign Up'),
        ),
      ]),
    );
  }
}
