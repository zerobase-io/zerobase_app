import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'zerobase_app_bar.dart';

class GetTested extends StatelessWidget {
  static final routeName = '/get_tested';
  static const testingInstructionsUrl =
      "https://www.cdc.gov/coronavirus/2019-ncov/symptoms-testing/testing.html";

  @override
  Widget build(BuildContext context) {
    const bodyTextStyle = TextStyle(fontSize: 18);
    return Scaffold(
      appBar: ZerobaseAppBar(
        title: "Testing Instructions",
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: <Widget>[
            Text("It's Time to Get Tested.", style: TextStyle(fontSize: 24)),
            Padding(padding: const EdgeInsets.all(8)),
            Text(
                "COVID-19 can be a serious disease, but we're here "
                "to help keep you safe, and to keep those in your community safe.",
                style: bodyTextStyle),
            Padding(padding: const EdgeInsets.all(8)),
            Text(
                "The next step is to get tested as soon as possible, and to avoid "
                "all unnecessary contact with others.",
                style: bodyTextStyle),
            Padding(padding: const EdgeInsets.all(8)),
            Text(
                "It is imperative to the health of your community and the world "
                "that you get tested for SARS-CoV-2 as soon as possible.",
                style: bodyTextStyle),
            Padding(padding: const EdgeInsets.all(8)),
            Text(
                "We've assembled all the information you need, and will help you "
                "find a testing site. Click the button below to get started.",
                style: bodyTextStyle),
            Padding(padding: const EdgeInsets.all(8)),
            RaisedButton(
              child: Text(
                "Testing Instructions",
                style: bodyTextStyle,
              ),
              onPressed: () {
                goToTestingInstructions();
              },
            )
          ]),
        ),
      ),
    );
  }

  static goToTestingInstructions() async {
    if (await canLaunch(testingInstructionsUrl)) {
      await launch(testingInstructionsUrl);
    } else {
      print("Couldn't launch browser to show self-isolation instructions.");
    }
  }
}
