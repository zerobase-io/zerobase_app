import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuple/tuple.dart';

import 'app/app_bloc.dart';
import 'device_ids/device_id_bloc.dart';
import 'messaging/messaging_bloc.dart';
import 'navigation/navigation_bloc.dart';

Future<Tuple2<A, B>> collate2<A, B>(Future<A> futureA, Future<B> futureB) =>
    Future.wait([futureA, futureB]).then((list) => Tuple2(list[0], list[1]));

abstract class Event<STATE, BLOC> {
  STATE apply(STATE state, BLOC bloc);
}

NavigationBloc navBlocFrom(context) {
  return BlocProvider.of<AppBloc>(context).navigationBloc;
}

MessagingBloc messagingBlocFrom(context) {
  return BlocProvider.of<AppBloc>(context).messagingBloc;
}

DeviceIdBloc deviceIdBlocFrom(context) {
  return BlocProvider.of<AppBloc>(context).deviceIdBloc;
}
