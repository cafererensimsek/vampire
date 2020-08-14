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
}
