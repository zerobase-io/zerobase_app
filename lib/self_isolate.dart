import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelfIsolate extends StatelessWidget {
  static final routeName = '/self_isolate';

  @override
  Widget build(BuildContext context) {
    const bodyTextStyle = TextStyle(fontSize: 18);
    return Scaffold(
      appBar: AppBar(
        title: Text('Self Isolation Instructions'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: <Widget>[
              Text("It's Time to Self-Isolate.", style: TextStyle(fontSize: 24)),
              Padding(padding: const EdgeInsets.all(8)),
              Text(
                  "The single most powerful tool we have against SARS-COV-2 is "
                  "social distancing.",
                  style: bodyTextStyle),
              Padding(padding: const EdgeInsets.all(8)),
              Text(
                  "Please immediately avoid all unnecessary contact with others, "
                  "and click the button below for further instructions.",
                  style: bodyTextStyle),
              Padding(padding: const EdgeInsets.all(8)),
              RaisedButton(
                child: Text("View Self-Isolation Instructions"),
                onPressed: (){
                  // Link off to appropriate site
                  print("View Self-Isolation Instructions()");
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
