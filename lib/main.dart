import 'package:flutter/material.dart';

import 'message_handler.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zerobase',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(title: 'Zerobase Exposure Tracker'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

scanQr(BuildContext context) {
  print('scanQr');
}

class _HomePageState extends State<HomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: MessageHandler(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          scanQr(context);
        },
        child: Icon(Icons.camera),
      ),
    );
  }
}
