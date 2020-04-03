import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../util.dart';
import 'device_id_bloc.dart';
import 'device_id_start.dart';

class DeviceIds extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DeviceIdState();
  }
}

class _DeviceIdState extends State<DeviceIds> {
  PageController _controller;
  double _pageVal = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.7, keepPage: false)
      ..addListener(_didScrollPage);
  }

  void _didScrollPage() {
    setState(() {
      _pageVal = _controller.page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text("Device Codes", style: TextStyle(color: Colors.white)),
      backgroundColor: Color(0xFF2a3742),
      children: <Widget>[
        Container(
            width: MediaQuery.of(context).size.width * .8,
            height: 280,
            child: BlocBuilder<DeviceIdBloc, DeviceIdState>(
              builder: (context, DeviceIdState state) {
                if (state is DeviceIdLoadedState) {
                  final allIds = [state.deviceId, ...state.alternateIds];
                  return PageView.builder(
                      itemBuilder: (context, index) {
                        if (index == allIds.length) {
                          return Center(
                            child: RaisedButton(
                              child: Text("Add New Alternate",
                                  style: TextStyle(fontSize: 18)),
                              onPressed: () {
                                deviceIdBlocFrom(context)
                                    .add(DeviceIdGenerateAlternateEvent());
                              },
                            ),
                          );
                        } else {
                          return Transform.scale(
                            child: _buildOneDeviceCode(
                                index == 0
                                    ? "Primary ID"
                                    : "Alternate ID #$index",
                                allIds[index]),
//                            child: Text(scale.toString()),

                            scale: 1.0 -(0.3 * (_pageVal - index)).abs(),
                          );
                        }
                      },
                      controller: _controller,
                      itemCount: allIds.length + 1);
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ))
      ],
    );
  }

  _buildOneDeviceCode(String name, String deviceId) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 8,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(name, style: TextStyle(fontSize: 20)),
              Padding(padding: const EdgeInsets.all(8.0)),
              QrImage(size: 200, data: "https://zerobase.io/s/$deviceId"),
            ],
          ),
        ),
      ),
    );
  }
}
