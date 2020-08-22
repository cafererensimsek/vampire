import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Widgets {
  // snackbar template to display errors
  Widget snackbar(txt) {
    return Builder(builder: (BuildContext context) {
      return SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline),
            SizedBox(width: 30),
            Flexible(child: Text(txt)),
          ],
        ),
      );
    });
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
      bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 20, 20, 20),
      child: TextField(
        cursorColor: Colors.white,
        controller: controller,
        obscureText: obscure,
        style: TextStyle(color: Colors.white),
        keyboardType: obscure ? null : TextInputType.emailAddress,
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
}
