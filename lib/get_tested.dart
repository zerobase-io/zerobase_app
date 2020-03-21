import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GetTested extends StatelessWidget {
  static final routeName = '/get_tested';

  @override
  Widget build(BuildContext context) {
    const bodyTextStyle = TextStyle(fontSize: 18);
    return Scaffold(
      appBar: AppBar(
        title: Text("SARS-COV-2 Testing Instructions"),
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
                "that you get tested for SARS-COV-2 as soon as possible.",
                style: bodyTextStyle),
            Padding(padding: const EdgeInsets.all(8)),
            Text(
                "We've assembled all the information you need, and will help you "
                "find a testing site. Click the button below to get started.",
                style: bodyTextStyle),
            Padding(padding: const EdgeInsets.all(8)),
            RaisedButton(
              child: Text("Find Testing Site", style: bodyTextStyle,),
              onPressed: () {
                // Link off to appropriate site
                print("Find Testing Site()");
              },
            )
          ]),
        ),
      ),
    );
  }
}
