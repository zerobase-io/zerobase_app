import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

import 'get_tested.dart';
import 'message_handler.dart';
import 'self_isolate.dart';
import 'self_report.dart';
import 'welcome.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Zerobase',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: HomePage.routeName,
        routes: {
          HomePage.routeName: (context) => HomePage(),
          GetTested.routeName: (context) => GetTested(),
          SelfIsolate.routeName: (context) => SelfIsolate(),
          Welcome.routeName: (context) => Welcome(),
          SelfReport.routeName: (context) => SelfReport()
        });
  }
}

class HomePage extends StatefulWidget {
  static final routeName = '/';

  HomePage({Key key}) : super(key: key);

  final String title = "Zerobase App";

  @override
  _HomePageState createState() => _HomePageState();
}

scanQr(BuildContext context) {
  print('scanQr');
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    initDynamicLinks();
  }

  @override
  Widget build(BuildContext context) {
    const bodyTextStyle = TextStyle(fontSize: 18);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          MessageHandler(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Center(child: Text("Zerobase", style: TextStyle(fontSize: 32))),
                Padding(padding: const EdgeInsets.all(16.0)),
                Text("Think you're sick? Don't worry, we're here for you!",
                    style: TextStyle(fontSize: 24)),
                Padding(padding: const EdgeInsets.all(16.0)),
                Text(
                    "If you believe it's time to self-isloate, we have easy "
                    "instructions for you. Thanks for keeping other safe!",
                    style: bodyTextStyle),
                Padding(padding: const EdgeInsets.all(8.0)),
                RaisedButton(
                  child: Text(
                    "Self Isolation Instructions",
                    style: bodyTextStyle,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, SelfIsolate.routeName);
                  },
                ),
                Padding(padding: const EdgeInsets.all(16.0)),
                Text(
                    "If you believe it's time to get tested for SARS-COV-2, "
                    "you can find instructions and help locating a testing "
                    "facility below. You're doing the right thing.",
                    style: bodyTextStyle),
                Padding(padding: const EdgeInsets.all(8.0)),
                RaisedButton(
                  child: Text("Get Tested", style: bodyTextStyle),
                  onPressed: () {
                    Navigator.pushNamed(context, GetTested.routeName);
                  },
                ),
                Padding(padding: const EdgeInsets.all(16.0)),
                Text(
                  "If you have visited a testing site and been tested for "
                  "SARS-COV-2, please self-report your test results to us.",
                  style: bodyTextStyle,
                ),
                Padding(padding: const EdgeInsets.all(8.0)),
                RaisedButton(
                  child: Text("Self-Report Test Results", style: bodyTextStyle),
                  onPressed: () {
                    Navigator.pushNamed(context, SelfReport.routeName);
                  },
                )
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          scanQr(context);
        },
        child: Icon(Icons.camera),
      ),
    );
  }

  void initDynamicLinks() async {
    final PendingDynamicLinkData initDynamicLink =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = initDynamicLink?.link;
    if (deepLink != null) {
      handleDeepLink(deepLink);
    }

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;
      handleDeepLink(deepLink);
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });
  }

  void handleDeepLink(Uri uri) {
    print("Dyanmic Link: " + uri.toString());
    Navigator.pushNamed(context, uri.path, arguments: uri.queryParameters);
  }
}
