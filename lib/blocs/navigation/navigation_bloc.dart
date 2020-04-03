import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';
import '../util.dart';
import 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  // There's an issue with dynamic link events being fired multiple times (this
  // is a bug in Flutterfire). For this reason, all dynlink events received by
  // NavigationBloc are routed directly into _dynLinkDebouncer, which is
  // ultimately responsible for handling the events.
  final PublishSubject<NavigationHandleDynamicLinkEvent> _dynLinkDebouncer =
      PublishSubject();

  NavigationBloc() {
    _dynLinkDebouncer.debounceTime(const Duration(milliseconds: 100)).listen(
        (event) => _pushNamed(event.uri.path, event.uri.queryParameters));
    _initDynLinks();
  }

  _initDynLinks() async {
    final PendingDynamicLinkData initDynamicLink =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = initDynamicLink?.link;
    if (deepLink != null) {
      add(NavigationHandleDynamicLinkEvent(deepLink));
    }

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;
      add(NavigationHandleDynamicLinkEvent(deepLink));
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });
  }

  _popToHome() {
    Get.offAllNamed(HomePage.routeName);
  }

  _popOnce() {
    Get.back();
  }

  _pushNamed(name, args) {
    Get.toNamed(name, arguments: args);
  }

  @override
  Future<void> close() {
    _dynLinkDebouncer.close();
    return super.close();
  }

  @override
  NavigationState get initialState => NavigationState();

  @override
  Stream<NavigationState> mapEventToState(NavigationEvent event) async* {
    yield event.apply(state, this);
  }
}

abstract class NavigationEvent
    implements Event<NavigationState, NavigationBloc> {}

class NavigationPopToHomeEvent extends NavigationEvent {
  @override
  NavigationState apply(NavigationState state, NavigationBloc bloc) {
    bloc._popToHome();
    return state;
  }
}

class NavigationPopOnceEvent extends NavigationEvent {
  @override
  NavigationState apply(NavigationState state, NavigationBloc bloc) {
    bloc._popOnce();
    return state;
  }
}

class NavigationPushNamedEvent extends NavigationEvent {
  final String name;
  final Map<String, dynamic> args;

  NavigationPushNamedEvent(this.name, {this.args});

  @override
  NavigationState apply(NavigationState state, NavigationBloc bloc) {
    bloc._pushNamed(name, args);
    return state;
  }
}

class NavigationHandleDynamicLinkEvent extends NavigationEvent {
  final Uri uri;

  NavigationHandleDynamicLinkEvent(this.uri);

  @override
  NavigationState apply(NavigationState state, NavigationBloc bloc) {
    bloc._dynLinkDebouncer.add(this);
    return state;
  }
}

class NavigationModalDialogEvent extends NavigationEvent {
  final Widget dialog;
  final bool dismissible;

  NavigationModalDialogEvent(this.dialog, this.dismissible);

  @override
  NavigationState apply(NavigationState state, NavigationBloc bloc) {
    Get.dialog(dialog, barrierDismissible: dismissible);

    return state;
  }
}

class NavigationDialNumberEvent extends NavigationEvent {
  final String number;

  NavigationDialNumberEvent(this.number);

  @override
  NavigationState apply(NavigationState state, NavigationBloc bloc) {
    launch('tel:$number');

    return state;
  }
}
