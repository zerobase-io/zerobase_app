import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeCard extends StatelessWidget {
  final headerColor;
  final button;
  final titleText;
  final bodyText;

  const HomeCard(
      {Key key,
      this.button,
      this.titleText,
      this.bodyText,
      this.headerColor = const Color(0xFF546E7A)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 10,
        child: Column(children: <Widget>[
          Container(
            child: Align(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(titleText,
                    style: TextStyle(fontSize: 28, color: Colors.white)),
              ),
              alignment: Alignment.topLeft,
            ),
            decoration: BoxDecoration(
                color: headerColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8), topRight: Radius.circular(8))),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                if (bodyText is String)
                  Text(bodyText, style: TextStyle(fontSize: 18)),
                if (bodyText is Widget) bodyText,
                Padding(padding: const EdgeInsets.all(4.0)),
                Align(alignment: Alignment.bottomRight, child: button)
              ],
            ),
          )
        ]));
  }
}
