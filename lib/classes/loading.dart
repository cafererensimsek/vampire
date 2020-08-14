import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
