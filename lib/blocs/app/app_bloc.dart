import 'package:flutter_bloc/flutter_bloc.dart';

import '../device_ids/device_id_bloc.dart';
import '../messaging/messaging_bloc.dart';
import '../navigation/navigation_bloc.dart';
import '../util.dart';
import 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final DeviceIdBloc _deviceIdBloc;
  final NavigationBloc _navigationBloc;
  final MessagingBloc _messagingBloc;

  AppBloc()
      : _deviceIdBloc = DeviceIdBloc(),
        _navigationBloc = NavigationBloc(),
        _messagingBloc = MessagingBloc() {
    // Need two Blocs to talk to each other? Link them here.
    _messagingBloc.navSink = _navigationBloc;
  }

  DeviceIdBloc get deviceIdBloc => _deviceIdBloc;

  NavigationBloc get navigationBloc => _navigationBloc;

  MessagingBloc get messagingBloc => _messagingBloc;

  @override
  get initialState => AppState();

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    yield event.apply(state, this);
  }
}

abstract class AppEvent extends Event<AppState, AppBloc> {}
