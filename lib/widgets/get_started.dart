import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../blocs/device_ids/device_id_bloc.dart';
import '../blocs/navigation/navigation_bloc.dart';
import '../blocs/util.dart';
import '../todo.dart';

class GetStarted extends StatefulWidget {
  @override
  _GetStartedState createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  Widget _body;

  @override
  void initState() {
    super.initState();

    _body = Column(
      children: <Widget>[
        Text("Let's Get Started", style: TextStyle(fontSize: 24)),
        Padding(padding: const EdgeInsets.all(8.0)),
        Text("Have you used our website, zerobase.io?",
            style: TextStyle(fontSize: 20)),
        Padding(padding: const EdgeInsets.all(8.0)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            RaisedButton(
              child: Text("Yes", style: TextStyle(fontSize: 18)),
              onPressed: () => _showGettingWebsiteId(),
            ),
            RaisedButton(
              child: Text("No", style: TextStyle(fontSize: 18)),
              onPressed: () => _showMakingNewId(),
            ),
          ],
        )
      ],
    );
  }

  _showMakingNewId() {
    setState(() {
      _body = IntrinsicHeight(
        child: Column(children: <Widget>[
          Text(
            "Welcome to Zerobase!",
            style: TextStyle(fontSize: 24),
          ),
          Padding(padding: const EdgeInsets.all(8.0)),
          Text(
            "We're going to generate a new Zerobase ID for you.",
            style: TextStyle(fontSize: 20),
          ),
          Padding(padding: const EdgeInsets.all(16.0)),
          RaisedButton(
            child: Text(
              "Generate ID",
              style: TextStyle(fontSize: 18),
            ),
            onPressed: () {
              deviceIdBlocFrom(context).add(DeviceIdGeneratePrimaryEvent());
              _showLetsGetScanning();
            }
                ,
          )
        ]),
      );
    });
  }

  _showGettingWebsiteId() {
    setState(() {
      _body = IntrinsicHeight(
        child: Column(children: <Widget>[
          Text(
            "Welcome Back!",
            style: TextStyle(fontSize: 24),
          ),
          Padding(padding: const EdgeInsets.all(8.0)),
          Text(
            "We're going to visit zerobase.io for you to copy over your Zerobase ID.",
            style: TextStyle(fontSize: 20),
          ),
          Padding(padding: const EdgeInsets.all(16.0)),
          RaisedButton(
            child: Text(
              "OK",
              style: TextStyle(fontSize: 18),
            ),
            onPressed: () {
              TODO("Jump to website to copy ID");
              launch("https://zerobase.io");
            },
          )
        ]),
      );
    });
  }

  _showLetsGetScanning() {
    setState(() {
      _body = IntrinsicHeight(
        child: Column(
          children: <Widget>[
            Text(
              "You're all set!",
              style: TextStyle(fontSize: 24),
            ),
            Padding(padding: const EdgeInsets.all(8.0)),
            Text("Let's get to scanning!", style: TextStyle(fontSize: 20)),
            Padding(padding: const EdgeInsets.all(8.0)),
            RaisedButton(
              child: Text(
                "Exit Setup",
                style: TextStyle(fontSize: 18),
              ),
              onPressed: () =>
                  navBlocFrom(context).add(NavigationPopOnceEvent()),
            )
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
                child: AnimatedSwitcher(
              child: _body,
              duration: Duration(milliseconds: 300),
            )),
          ),
        )
      ],
    );
  }
}
