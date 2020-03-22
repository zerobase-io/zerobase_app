import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'get_tested.dart';
import 'models/message_type.dart';
import 'self_isolate.dart';

//https://fireship.io/lessons/flutter-push-notifications-fcm-guide/

class MessageHandler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _MessagingHandlerService(context);
    return Container(width: 0, height: 0);
  }
}

/// There's not a great way to get around a bug in the FCM plugin for Flutter
/// at the moment, but this works for the time being.
/// This singleton is responsible for receiving/processing FCM messages and, in
/// order to keep track of duplicate messages, stores the IDs of the messages it
/// has seen during this session (cleared on restart) to filter out duplicates.
///
/// This is where it gets a little clever or janky, depending on how generous
/// we're being:
/// Every time a MessageHandler widget is built, we also construct a new
/// _MessagingHandlerService but don't persist it. The factory for
/// _MessagingHandlerService takes a BuildContext as an argument, and sets the
/// buildContext field of _inst to the provided context. Then, when we receive a
/// message, that persisted BuildContext is used to push the appropriate Widget
/// for the received message onto the nav stack. This effectively means any time
/// a new MessageHandler is built, whichever context it was built with is now
/// the context which we'll use for navigation. It might be bad practice to
/// store the context in this manner, but this is working correctly and will
/// have to do for now.
class _MessagingHandlerService {
  static final _MessagingHandlerService _inst =
      new _MessagingHandlerService._internal();

  factory _MessagingHandlerService(BuildContext buildContext) {
    _inst.buildContext = buildContext;
    return _inst;
  }

  final FirebaseMessaging _fcm = FirebaseMessaging();
  final List<String> handledMessageIds = new List();
  BuildContext buildContext;

  _MessagingHandlerService._internal() {
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        handleMessage(message);
      },
      onResume: (Map<String, dynamic> message) async {
        handleMessage(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        handleMessage(message);
      },
    );
  }

  void handleMessage(Map<String, dynamic> message) {
    try {
      final data = new Map<String, dynamic>.from(message['data']);
      final String messageTypeStr = data['messageType'];
      final String messageId = data['id'];
      if (!handledMessageIds.contains(messageId)) {
        final MessageType resolvedMsgTypeEnum = MessageType.values.firstWhere(
                (testMsgTypeEnum) =>
            testMsgTypeEnum.toString().split('.').last == messageTypeStr);
        final routes = {
          MessageType.GET_TESTED: GetTested.routeName,
          MessageType.SELF_ISOLATE: SelfIsolate.routeName
        };
        final route = routes[resolvedMsgTypeEnum];
        Navigator.pushNamed(buildContext, route);
        handledMessageIds.add(messageId);
      }
    } catch (e) {
      print("Failed to nav for message: $message, error: $e");
    }
  }
}
