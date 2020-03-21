import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class Welcome extends StatelessWidget {
  static const routeName = '/welcome';
  static const DEVICE_ID_ARG = "deviceFp";

  final _fcm = FirebaseMessaging();

  @override
  Widget build(BuildContext context) {
    final Map<String, String> args = ModalRoute.of(context).settings.arguments;

    // Strip quotes from device ID
    final topic = args[DEVICE_ID_ARG].replaceAll('"', '');
    print("Subscribing to topic: $topic");
    _fcm.subscribeToTopic(topic);

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to Zerobase!'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text("Welcome!", style: TextStyle(fontSize: 32)),
            Padding(padding: const EdgeInsets.all(16.0)),
            Text("You're registered and good to go."),
            Padding(padding: const EdgeInsets.all(8.0)),
            RaisedButton(
              child: Text("Return to Home"),
              onPressed: () => Navigator.popUntil(
                context,
                ModalRoute.withName(HomePage.routeName),
              ),
            )
          ],
        ),
      ),
    );
  }
}
