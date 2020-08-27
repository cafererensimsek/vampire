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
  String _email;
  String _password;

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
    _email = emailController.text;
  }

  _changePassword() {
    _password = passwordController.text;
  }

  void auth(BuildContext context) async {
    {
      try {
        FirebaseUser user = (await FirebaseAuth.instance
                .signInWithEmailAndPassword(email: _email, password: _password))
            .user;
        Player player = new Player(
            name: user.email.substring(0, user.email.indexOf('@')),
            isAdmin: true,
            role: 'villager');
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Home(player: player)));
      } catch (e) {
        switch (e.code) {
          case "ERROR_USER_NOT_FOUND":
            if (_password.length >= 6) {
              try {
                FirebaseUser user = (await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: _email, password: _password))
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
                Scaffold.of(context).showSnackBar(snackbar(e.message));
              }
            } else {
              Scaffold.of(context).showSnackBar(
                  snackbar('Password must be at least 6 characters!'));
            }
            break;
          default:
            Scaffold.of(context).showSnackBar(snackbar(e.message));
            break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('lib/assets/background.jpg'),
              fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Builder(builder: (BuildContext context) {
          return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            textInput(
                controller: emailController,
                hintText: 'Email',
                icon: Icon(Icons.email, color: Colors.white),
                keyboardType: TextInputType.emailAddress),
            textInput(
                controller: passwordController,
                hintText: 'Password',
                icon: Icon(Icons.vpn_key, color: Colors.white),
                obscure: true),
            FlatButton(
              color: Colors.transparent,
              child: Text(
                'Sign In/Sign Up',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => auth(context),
            ),
          ]);
        }),
      ),
    );
  }
}
