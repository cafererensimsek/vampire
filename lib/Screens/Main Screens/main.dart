import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Game Screens/home.dart';

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
      home: Body(),
    );
  }
}

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String email;
  String password;

  // snackbar template to display errors
  snackbar(txt) {
    return SnackBar(
      content: Row(
        children: [
          Icon(Icons.error_outline),
          SizedBox(width: 30),
          Flexible(child: Text(txt)),
        ],
      ),
    );
  }

  // initState for controllers
  @override
  void initState() {
    super.initState();
    emailController.addListener(_changeEmail);
    passwordController.addListener(_changePassword);
  }

  // dispose for controllers
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // the functions to get email and password
  _changeEmail() {
    email = emailController.text;
  }

  _changePassword() {
    password = passwordController.text;
  }

  // firebase signup function
  signUp() async {
    try {
      FirebaseUser user = (await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: email, password: password))
          .user;

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Home(user: user)));
    } catch (e) {
      Scaffold.of(context).showSnackBar(snackbar(e.message));
    }
  }

  // tries to log in, if user not found signs it up and sends to home page,
  //if neither shows the error
  Widget button() {
    return Builder(
      builder: (context) => FlatButton(
        onPressed: () async {
          try {
            FirebaseUser user = (await FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                        email: email, password: password))
                .user;
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Home(user: user)));
          } catch (e) {
            switch (e.code) {
              case "ERROR_USER_NOT_FOUND":
                if (password.length >= 6) {
                  signUp();
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
        },
        child: Text('Sign In/Sign Up'),
      ),
    );
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
        TextField(
          controller: passwordController,
          obscureText: true,
          decoration: InputDecoration(
            icon: Icon(Icons.vpn_key),
            hintText: 'Password',
          ),
        ),
        button(),
      ]),
    );
  }
}
