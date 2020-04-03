import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'zerobase_app_bar.dart';

class SelfIsolate extends StatelessWidget {
  static final routeName = '/self_isolate';
  static const selfIsolationInstructionsUrl =
      "https://www.cdc.gov/coronavirus/2019-ncov/if-you-are-sick/index.html";

  @override
  Widget build(BuildContext context) {
    const bodyTextStyle = TextStyle(fontSize: 18);
    return Scaffold(
      appBar: ZerobaseAppBar(
        title: "Self Isolation Instructions",
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: <Widget>[
              Text("It's Time to Self-Isolate.",
                  style: TextStyle(fontSize: 24)),
              Padding(padding: const EdgeInsets.all(8)),
              Text(
                  "The single most powerful tool we have against SARS-CoV-2 is "
                  "social distancing.",
                  style: bodyTextStyle),
              Padding(padding: const EdgeInsets.all(8)),
              Text(
                  "Please immediately avoid discontinue unnecessary contact "
                  "with others, and click the button below for further "
                  "instructions.",
                  style: bodyTextStyle),
              Padding(padding: const EdgeInsets.all(8)),
              RaisedButton(
                child: Text("View Self-Isolation Instructions", style: TextStyle(fontSize: 18)),
                onPressed: goToTestingInstructions,
              )
            ],
          ),
        ),
      ),
    );
  }

  static goToTestingInstructions() async {
    if (await canLaunch(selfIsolationInstructionsUrl)) {
      await launch(selfIsolationInstructionsUrl);
    } else {
      print("Couldn't launch browser to show self-isolation instructions.");
    }
  }
}
