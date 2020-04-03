import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';

import '../navigation/navigation_bloc.dart';
import '../util.dart';
import 'device_id_start.dart';

typedef String IdProvider();

class DeviceIdBloc extends Bloc<DeviceIdEvent, DeviceIdState> {
  // These are exposed only for testing, device code should only be accessed
  // through Bloc
  static const DEVICE_ID_KEY = "deviceId";
  static const ALTERNATE_IDS_KEY = "alternateIds";

  static const NoDeviceId = "No device ID when it must be preset!";
  static const CannotInitTwice = "_Init called when state wasn't empty!";
  static const CannotCallBeforeInit = "Cannot add event before _Init!";
  static const CannotReplacePrimaryWithGenerated =
      "Cannot replace primary ID with a new generated one!";

  IdProvider idProvider = () {
    var random = Random.secure();
    var values = List<int>.generate(12, (i) => random.nextInt(256))
        .map((int) => int.toRadixString(16).padLeft(4, '0'));
    return values.join();
  };

  DeviceIdBloc() {
    collate2(_getPrimaryId(), _getAlternateIds())
        .then((tuple) => _Init(tuple.item1, tuple.item2))
        .then(add);
  }

  Future<String> _getPrimaryId() async => SharedPreferences.getInstance()
      .then((prefs) => prefs.getString(DEVICE_ID_KEY));

  Future<String> _setPrimaryId(String primaryId) async =>
      SharedPreferences.getInstance()
          .then((prefs) => prefs.setString(DEVICE_ID_KEY, primaryId))
          .then((_) => primaryId);

  Future<String> _saveNewAlternateId(String newId) async {
    return _getAltFutures().then((prefsAltsTuple) {
      prefsAltsTuple.item1
          .setStringList(ALTERNATE_IDS_KEY, prefsAltsTuple.item2..add(newId));
      return newId;
    });
  }

  Future<List<String>> _getAlternateIds() async =>
      _getAltFutures().then(((prefsAltsTuple) => prefsAltsTuple.item2));

  Future<Tuple2<SharedPreferences, List<String>>> _getAltFutures() =>
      SharedPreferences.getInstance().then((prefs) {
        final altIds = prefs.getStringList(ALTERNATE_IDS_KEY);
        return Tuple2(prefs, altIds == null ? [] : altIds);
      });

  @override
  get initialState {
    return DeviceIdEmptyState();
  }

  @override
  Stream<DeviceIdState> mapEventToState(DeviceIdEvent event) async* {
    yield event.apply(state, this);
  }
}

abstract class DeviceIdEvent implements Event<DeviceIdState, DeviceIdBloc> {}

class _Init extends Equatable implements DeviceIdEvent {
  final newDeviceId;
  final newAltIds;

  _Init(this.newDeviceId, this.newAltIds);

  @override
  DeviceIdLoadedState apply(DeviceIdState state, _) {
    if (state is DeviceIdEmptyState) {
      return DeviceIdLoadedState(newDeviceId, newAltIds);
    } else {
      throw DeviceIdBloc.CannotInitTwice;
    }
  }

  @override
  String toString() {
    return "_Init{$newDeviceId, $newAltIds}";
  }

  @override
  List<Object> get props => [newAltIds, newDeviceId];
}

class DeviceIdDoIfNoPrimaryEvent extends Equatable implements DeviceIdEvent {
  final Function() thingToDo;

  DeviceIdDoIfNoPrimaryEvent(this.thingToDo);

  @override
  DeviceIdState apply(DeviceIdState state, DeviceIdBloc bloc) {
    bloc._getPrimaryId().then((primaryId) {
      print("DeviceIdDoIfNoPrimaryEvent.apply: $primaryId");
      if (primaryId == null) thingToDo();
    });
    return state;
  }

  @override
  List<Object> get props => [thingToDo];
}

class DeviceIdInitializePrimaryEvent extends Equatable
    implements DeviceIdEvent {
  final newPrimaryId;

  DeviceIdInitializePrimaryEvent(this.newPrimaryId);

  @override
  DeviceIdLoadedState apply(DeviceIdState state, DeviceIdBloc bloc) {
    bloc._setPrimaryId(newPrimaryId);
    if (state is DeviceIdLoadedState) {
      return DeviceIdLoadedState(newPrimaryId, state.alternateIds);
    } else {
      throw DeviceIdBloc.CannotCallBeforeInit;
    }
  }

  @override
  String toString() {
    return "InitializePrimaryId{$newPrimaryId}";
  }

  @override
  List<Object> get props => [newPrimaryId];
}

class DeviceIdGeneratePrimaryEvent extends Equatable implements DeviceIdEvent {
  @override
  DeviceIdState apply(DeviceIdState state, DeviceIdBloc bloc) {
    if (state is DeviceIdLoadedState) {
      if (state.deviceId != null) {
        throw DeviceIdBloc.CannotReplacePrimaryWithGenerated;
      }
      final primaryId = bloc.idProvider();
      bloc._setPrimaryId(primaryId);
      return DeviceIdLoadedState(primaryId, state.alternateIds);
    } else {
      throw DeviceIdBloc.CannotCallBeforeInit;
    }
  }

  @override
  List<Object> get props => [];
}

class DeviceIdDeletePrimaryEvent extends Equatable implements DeviceIdEvent {
  @override
  DeviceIdLoadedState apply(DeviceIdState state, DeviceIdBloc bloc) {
    bloc._setPrimaryId(null);
    if (state is DeviceIdLoadedState) {
      return DeviceIdLoadedState(null, state.alternateIds);
    } else {
      throw DeviceIdBloc.CannotCallBeforeInit;
    }
  }

  @override
  List<Object> get props => null;
}

class DeviceIdGenerateAlternateEvent extends Equatable
    implements DeviceIdEvent {
  @override
  DeviceIdLoadedState apply(DeviceIdState state, DeviceIdBloc bloc) {
    final generatedId = bloc.idProvider();
    bloc._saveNewAlternateId(generatedId);

    if (state is DeviceIdLoadedState) {
      return new DeviceIdLoadedState(
          state.deviceId, List.from(state.alternateIds)..add(generatedId));
    } else {
      throw DeviceIdBloc.CannotCallBeforeInit;
    }
  }

  @override
  List<Object> get props => null;
}
