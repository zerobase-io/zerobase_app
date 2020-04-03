import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/device_ids/device_id_bloc.dart';
import '../blocs/navigation/navigation_bloc.dart';
import '../blocs/util.dart';
import 'zerobase_app_bar.dart';

class Welcome extends StatelessWidget {
  static const routeName = '/welcome';
  static const DEVICE_ID_DYN_LINK_ARG = "deviceId";

  @override
  Widget build(BuildContext context) {
    final _fcm = FirebaseMessaging();

    final Map<String, String> args = ModalRoute.of(context).settings.arguments;

    // Strip quotes from device ID
    final deviceId = args[Welcome.DEVICE_ID_DYN_LINK_ARG].replaceAll('"', '');

    print("Subscribing to topic ($deviceId)... ");
    _fcm
        .subscribeToTopic(deviceId)
        .then(($) => print("Subscribed."))
        .catchError((e) => print("Couldn't subscribe: $e"));

    deviceIdBlocFrom(context).add(DeviceIdInitializePrimaryEvent(deviceId));

    return Scaffold(
      appBar: ZerobaseAppBar(
        title: "Welcome!",
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: <Widget>[
              Text("Welcome!", style: TextStyle(fontSize: 32)),
              Padding(padding: const EdgeInsets.all(16.0)),
              Text(
                "You're registered and good to go.",
                style: TextStyle(fontSize: 18),
              ),
              Padding(padding: const EdgeInsets.all(8.0)),
              RaisedButton(
                  child: Text("Return to Home", style: TextStyle(fontSize: 18)),
                  onPressed: () =>
                      navBlocFrom(context).add(NavigationPopToHomeEvent()))
            ],
          ),
        ),
      ),
    );
  }
}
