import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/device_ids/device_id_bloc.dart';
import '../blocs/util.dart';

class ZerobaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget accessory;
  final String title;

  const ZerobaseAppBar({Key key, this.accessory, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    makeLogoWithIdReset() {
      return GestureDetector(
        onLongPress: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(
                    "Reset Device Id?",
                    style: TextStyle(fontSize: 24),
                  ),
                  actions: <Widget>[
                    RaisedButton(
                      onPressed: () async {
                        deviceIdBlocFrom(context).add(DeviceIdDeletePrimaryEvent());
                        Navigator.of(context).pop();
                      },
                      child: Text("Yes", style: TextStyle(fontSize: 18)),
                    )
                  ],
                );
              });
        },
        child: Container(
            height: 32,
            child: Image.network(
                "https://zerobase.io/assets/img/zerobase_logo_300_white.png")),
      );
    }

    final title = this.title != null
        ? Text(
            this.title,
            style: TextStyle(fontSize: 24, color: Colors.white),
          )
        : makeLogoWithIdReset();

    final accessory =
        this.accessory != null ? this.accessory : Container(height: 0);

    return AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[title, accessory],
        ),
        backgroundColor: const Color(0xFF2a3742));
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
