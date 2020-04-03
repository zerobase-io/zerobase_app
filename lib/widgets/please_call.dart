import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/navigation/navigation_bloc.dart';
import '../blocs/util.dart';

class PleaseCall extends StatelessWidget {
  final phoneNumber;

  const PleaseCall({Key key, this.phoneNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Please Call Immediately", style: TextStyle(fontSize: 24)),
              Padding(padding: const EdgeInsets.all(8.0)),
              Text(
                  "Your public health authority needs to speak with you immediately.",
                  style: TextStyle(
                    fontSize: 18,
                  )),
              Padding(padding: const EdgeInsets.all(8.0)),
              RaisedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.call),
                    Padding(padding: const EdgeInsets.all(8.0)),
                    Text("Call Now", style: TextStyle(fontSize: 18)),
                  ],
                ),
                onPressed: () => navBlocFrom(context)
                    .add(NavigationDialNumberEvent(phoneNumber)),
              )
            ],
          ),
        ),
      ),
    ]);
  }
}
