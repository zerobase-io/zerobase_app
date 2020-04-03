import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../todo.dart';
import 'zerobase_app_bar.dart';

class SelfReport extends StatelessWidget {
  static final routeName = "self_report";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZerobaseAppBar(
        title: "Testing Self-Reporting",
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
                style: TextStyle(fontSize: 18)),
            Padding(padding: const EdgeInsets.all(8.0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RaisedButton(
                  child: Text("I Tested Positive", style: TextStyle(fontSize: 18)),
                  onPressed: () {
                    confirmTestResult(context, true);
                  },
                  color: Colors.green[300],
                ),
                RaisedButton(
                  child: Text("I Tested Negative", style: TextStyle(fontSize: 18)),
                  onPressed: () {
                    confirmTestResult(context, false);
                  },
                  color: Colors.red[300],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

void confirmTestResult(BuildContext context, bool positiveResult) {
  final resultStr = positiveResult ? "POSITIVE" : "NEGATIVE";
  final coloredResultStr = TextSpan(
      text: resultStr,
      style: TextStyle(
          color: positiveResult ? Colors.green[600] : Colors.red[600],
          fontSize: 20));

  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: Text("Just To Confirm..."),
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
          RaisedButton(
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
          RaisedButton(
            child: RichText(
                text: TextSpan(
                    style: TextStyle(fontSize: 16, color: Colors.black),
                    children: <TextSpan>[
                  TextSpan(
                      text: "NO",
                      style: TextStyle(color: Colors.red[600], fontSize: 20)),
                  TextSpan(text: ", let me change my answer")
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
  TODO("Confirmed positive");
}

void confirmedTestedNegative() {
  TODO("Confirmed negative");
}
