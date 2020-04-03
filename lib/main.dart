import 'package:barcode_scan/barcode_scan.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'bloc_delegate.dart';
import 'blocs/app/app_bloc.dart';
import 'blocs/device_ids/device_id_widget.dart';
import 'blocs/device_ids/device_id_bloc.dart';
import 'blocs/device_ids/device_id_start.dart';
import 'blocs/navigation/navigation_bloc.dart';
import 'blocs/util.dart';
import 'widgets/get_started.dart';
import 'widgets/get_tested.dart';
import 'widgets/home_card.dart';
import 'widgets/self_isolate.dart';
import 'widgets/self_report.dart';
import 'todo.dart';
import 'widgets/welcome.dart';
import 'widgets/zerobase_app_bar.dart';

void main() {
  // Log transitions & events
  BlocSupervisor.delegate = DebugDelegate();

  return runApp(BlocProvider(
    create: (context) => AppBloc(),
    child: MultiBlocProvider(providers: [
      // Make child BLoCs accessible for BlocBuilders
      BlocProvider(create: (context) => deviceIdBlocFrom(context)),
      BlocProvider(create: (context) => messagingBlocFrom(context)),
      BlocProvider(create: (context) => navBlocFrom(context)),
    ], child: App()),
  ));
}

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Zerobase',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        navigatorKey: Get.key,
        // Because we're using Get for navigation
        initialRoute: HomePage.routeName,
        routes: {
          HomePage.routeName: (context) => HomePage(),
          GetTested.routeName: (context) => GetTested(),
          SelfIsolate.routeName: (context) => SelfIsolate(),
          Welcome.routeName: (context) => Welcome(),
          SelfReport.routeName: (context) => SelfReport(),
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

enum PlusMenuOptions {
  SCAN,
  DEVICE_CODE,
}

class _HomePageState extends State<HomePage> {
  static const scanRegexStr = r"https?:\/\/zerobase.io\/s\/([\da-f]{24}$)";
  static final scanRegex =
      RegExp(scanRegexStr, caseSensitive: true, multiLine: false);

  @override
  void initState() {
    super.initState();

    deviceIdBlocFrom(context).add(DeviceIdDoIfNoPrimaryEvent(
      () => navBlocFrom(context)
          .add(NavigationModalDialogEvent(GetStarted(), false)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    const bodyTextStyle = TextStyle(fontSize: 18);

    makePopupMenuButton() {
      return PopupMenuButton<PlusMenuOptions>(
        child: Icon(
          Icons.add_circle_outline,
          size: 32,
        ),
        itemBuilder: (context) {
          var list = List<PopupMenuEntry<PlusMenuOptions>>();
          list.add(PopupMenuItem<PlusMenuOptions>(
            value: PlusMenuOptions.SCAN,
            child: Text("Scan"),
          ));
          list.add(PopupMenuItem<PlusMenuOptions>(
            value: PlusMenuOptions.DEVICE_CODE,
            child: Text("Device Code"),
          ));
          return list;
        },
        onSelected: (selected) async {
          switch (selected) {
            case PlusMenuOptions.SCAN:
              BarcodeScanner.scan()
                  .then((barcode) => scanRegex.firstMatch(barcode)?.group(1))
                  .then((fingerprint) => TODO("Create CheckIn: $fingerprint"))
                  .catchError((e) {
                if (e == BarcodeScanner.CameraAccessDenied) {
                  Flushbar(
                    title: "Camera Access Denied",
                    message: "Camera access is required to scan QR codes. "
                        "You can also use your phone's camera app.",
                    duration: Duration(seconds: 5),
                  )..show(context);
                } else if (e == BarcodeScanner.UserCanceled) {}
              });
              break;
            case PlusMenuOptions.DEVICE_CODE:
              navBlocFrom(context)
                  .add(NavigationModalDialogEvent(DeviceIds(), true));
              break;
          }
        },
      );
    }

    return Scaffold(
      appBar:
          ZerobaseAppBar(accessory: BlocBuilder<DeviceIdBloc, DeviceIdState>(
        builder: (context, DeviceIdState state) {
          if (state is DeviceIdLoadedState && state.deviceId != null) {
            return makePopupMenuButton();
          } else {
            return RaisedButton(
              child: Text("Get Started", style: TextStyle(fontSize: 18)), onPressed: () => navBlocFrom(context)
              .add(NavigationModalDialogEvent(GetStarted(), true)),
            );
          }
        },
      )),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Padding(padding: const EdgeInsets.all(8.0)),
                HomeCard(
                  titleText: "Self Isolate",
                  bodyText:
                      "If you believe it's time to self-isloate, we have easy "
                      "instructions for you. Thanks for keeping others safe!",
                  button: RaisedButton(
                    child: Text(
                      "Self Isolation Instructions",
                      style: bodyTextStyle,
                    ),
                    onPressed: SelfIsolate.goToTestingInstructions,
                    onLongPress: () => navBlocFrom(context)
                        .add(NavigationPushNamedEvent(SelfIsolate.routeName)),
                  ),
                ),
                Padding(padding: const EdgeInsets.all(8.0)),
                HomeCard(
                  titleText: "Get Tested",
                  bodyText:
                      "If you believe it's time to get tested for SARS-CoV-2, "
                      "you can find instructions and help locating a testing "
                      "facility below. You're doing the right thing.",
                  button: RaisedButton(
                    child: Text("Get Tested", style: bodyTextStyle),
                    onPressed: GetTested.goToTestingInstructions,
                    onLongPress: () => navBlocFrom(context)
                        .add(NavigationPushNamedEvent(GetTested.routeName)),
                  ),
                ),
                Padding(padding: const EdgeInsets.all(8.0)),
                HomeCard(
                  titleText: "Self-Report Test Results",
                  bodyText:
                      "If you have visited a testing site and been tested for "
                      "SARS-CoV-2, please self-report your test results to us. "
                      "Providing us this data is entirely voluntary but abolsutely "
                      "critical to our ability to protect your community and loved ones.",
                  button: RaisedButton(
                      child: Text("Self-Report Test Results",
                          style: bodyTextStyle),
                      onPressed: () => navBlocFrom(context)
                          .add(NavigationPushNamedEvent(SelfReport.routeName))),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
