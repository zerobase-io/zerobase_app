import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../models/message_type.dart';
import '../../widgets/get_tested.dart';
import '../../widgets/please_call.dart';
import '../../widgets/self_isolate.dart';
import '../navigation/navigation_bloc.dart';
import '../util.dart';
import 'messaging_state.dart';

class MessagingBloc extends Bloc<MessagingEvent, MessagingState> {
  static const NoEventForMessageType = "Couldn't find event for message type!";

  final FirebaseMessaging _fcm = FirebaseMessaging();
  Sink<NavigationEvent> _navSink;

  MessagingBloc() {
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async =>
          add(MessagingReceivedEvent(message)),
      onResume: (Map<String, dynamic> message) async =>
          add(MessagingReceivedEvent(message)),
      onLaunch: (Map<String, dynamic> message) async =>
          add(MessagingReceivedEvent(message)),
    );
  }

  set navSink(sink) => _navSink = sink;

  String _getIdFromMessage(Map<String, dynamic> message) {
    final data = new Map<String, dynamic>.from(message['data']);
    return data['id'];
  }

  _handleMessage(Map<String, dynamic> message) {
    try {
      final data = new Map<String, dynamic>.from(message['data']);
      final String messageTypeStr = data['messageType'];
      final MessageType resolvedMsgTypeEnum = MessageType.values.firstWhere(
          (testMsgTypeEnum) =>
              testMsgTypeEnum.toString().split('.').last == messageTypeStr);

      const NOOP = 0;

      final event = {
        MessageType.GET_TESTED: NavigationPushNamedEvent(GetTested.routeName),
        MessageType.SELF_ISOLATE:
            NavigationPushNamedEvent(SelfIsolate.routeName),
        MessageType.PLEASE_CALL: NavigationModalDialogEvent(
            PleaseCall(phoneNumber: data['phoneNumber']), true),
        MessageType.CUSTOM: NOOP,
      }[resolvedMsgTypeEnum];

      if (event != null) {
        if (event != NOOP) _navSink.add(event);
      } else {
        throw NoEventForMessageType;
      }
    } catch (e) {
      print("Failed to nav for message: $message, error: $e");
    }
  }

  @override
  MessagingState get initialState => MessagingState([]);

  @override
  Stream<MessagingState> mapEventToState(MessagingEvent event) async* {
    yield event.apply(state, this);
  }
}

abstract class MessagingEvent extends Event<MessagingState, MessagingBloc> {}

class MessagingReceivedEvent extends MessagingEvent {
  final Map<String, dynamic> message;

  MessagingReceivedEvent(this.message);

  @override
  MessagingState apply(MessagingState state, MessagingBloc bloc) {
    final messageId = bloc._getIdFromMessage(message);
    if (!state.handledMessageIds.contains(messageId)) {
      bloc._handleMessage(message);
      return MessagingState(state.handledMessageIds..add(messageId));
    } else {
      return state;
    }
  }
}
