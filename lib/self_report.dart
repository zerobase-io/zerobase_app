import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelfReport extends StatelessWidget {
  static final routeName = "self_report";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SARS-COV-2 Testing Self-Reporting"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Center(
              child: Text("Thanks For Getting Tested!",
                  style: TextStyle(fontSize: 28)),
            ),
            Padding(padding: const EdgeInsets.all(16.0)),
            Text(
                "You've done yourself and your community a huge service. "
                "If you're willing, please let us know your test results so that "
                "we can better inform your fellow community members and public "
                "health officials about the spread of this virus.",
                style: TextStyle(fontSize: 16)),
            Padding(padding: const EdgeInsets.all(8.0)),
            RaisedButton(
              child: Text("I Tested Positive", style: TextStyle(fontSize: 16)),
              onPressed: () {
                confirmTestResult(context, true);
              },
              color: Colors.green[300],
            ),
            Padding(padding: const EdgeInsets.all(8.0)),
            RaisedButton(
              child: Text("I Tested Negative", style: TextStyle(fontSize: 16)),
              onPressed: () {
                confirmTestResult(context, false);
              },
              color: Colors.red[300],
            ),
          ],
        ),
      ),
    );
  }
}

void confirmTestResult(BuildContext context, bool positiveResult) {
  final resultStr = positiveResult ? "POSITIVE" : "NEGATIVE";
  final coloredResultStr = new TextSpan(
      text: resultStr,
      style: TextStyle(
          color: positiveResult ? Colors.green[600] : Colors.red[600],
          fontSize: 20));

  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text("Just To Confirm..."),
        content: RichText(
            text: TextSpan(
                style: TextStyle(fontSize: 18, color: Colors.black),
                children: <TextSpan>[
              TextSpan(text: "You tested "),
              coloredResultStr,
              TextSpan(text: ", correct?")
            ])),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new RaisedButton(
            child: RichText(
                text: TextSpan(
                    style: TextStyle(fontSize: 16, color: Colors.black),
                    children: <TextSpan>[
                  TextSpan(
                      text: "YES",
                      style: TextStyle(color: Colors.green[600], fontSize: 20)),
                  TextSpan(text: ", I tested "),
                  coloredResultStr,
                ])),
            onPressed: () {
              (positiveResult
                  ? confirmedTestedPositive
                  : confirmedTestedNegative)();
              Navigator.of(context).pop();
            },
          ),
          new RaisedButton(
            child: RichText(
                text: TextSpan(
                    style: TextStyle(fontSize: 16, color: Colors.black),
                    children: <TextSpan>[
                  new TextSpan(
                      text: "NO",
                      style: TextStyle(color: Colors.red[600], fontSize: 20)),
                  new TextSpan(text: ", let me change my answer")
                ])),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void confirmedTestedPositive() {
  print("Confirmed positive");
}

void confirmedTestedNegative() {
  print("Confirmed negative");
}
