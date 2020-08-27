import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Widget snackbar(txt) {
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

// loading spinkit
Widget loading(context) {
  return Scaffold(
    backgroundColor: Theme.of(context).accentColor,
    body: Center(
      child: SpinKitFadingCube(
        color: Theme.of(context).primaryColor,
        size: 100.0,
      ),
    ),
  );
}

Widget textInput(
    {TextEditingController controller,
    String hintText,
    Icon icon,
    bool obscure = false,
    TextInputType keyboardType}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(10, 20, 20, 20),
    child: TextField(
      cursorColor: Colors.white,
      controller: controller,
      obscureText: obscure,
      style: TextStyle(color: Colors.white),
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white),
        icon: icon,
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
            borderSide: BorderSide(color: Colors.white)),
      ),
    ),
  );
}

Widget floatingAction(
    {String label,
    IconData icon,
    Function onpressed,
    num fontSize = 10,
    BuildContext context}) {
  return FloatingActionButton.extended(
    label: Text(
      label,
      style: TextStyle(color: Colors.black),
    ),
    icon: Icon(icon, color: Colors.black),
    onPressed: onpressed,
  );
}
