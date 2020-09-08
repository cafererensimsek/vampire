import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'shared/widgets.dart';
import 'home.dart';

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
          backgroundColor: Colors.white,
        ),
      ),
      home: Authentication(),
    );
  }
}

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
    try {
      FirebaseUser user = (await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: _email, password: _password))
          .user;
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => Home(email: user.email)));
    } catch (e) {
      switch (e.code) {
        case "ERROR_USER_NOT_FOUND":
          if (_password.length > 5) {
            try {
              FirebaseUser user = (await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: _email, password: _password))
                  .user;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Home(email: user.email)));
            } catch (e) {
              Scaffold.of(context).showSnackBar(snackbar(e.message));
            }
          } else {
            Scaffold.of(context).showSnackBar(
                snackbar('Password must be at least 6 characters long!'));
          }
          break;
        default:
          Scaffold.of(context).showSnackBar(snackbar(e.message));
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Builder(builder: (context) {
          return Column(children: [
            SizedBox(height: 250),
            Text('Login or Sign Up',
                style: TextStyle(color: Colors.white, fontSize: 25)),
            SizedBox(height: 50),
            textInput(
                controller: emailController,
                hintText: 'Email',
                //icon: Icon(Icons.email, color: Colors.white),
                keyboardType: TextInputType.emailAddress),
            textInput(
                controller: passwordController,
                hintText: 'Password',
                //icon: Icon(Icons.vpn_key, color: Colors.white),
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
