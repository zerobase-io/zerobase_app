import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';

import '../lib/blocs/device_ids/device_id_bloc.dart';
import '../lib/blocs/device_ids/device_id_start.dart';
import 'testware.dart';

void main() {
  const TEST_PRIMARY_ID = "asdf1234jklx5678zxcv9090";
  const TEST_ALT_IDS = [
    "0909vcxz8765xlkj4321fdsa",
    "909vcxz8765xlkj4321fdsa0",
    "09vcxz8765xlkj4321fdsa09",
    "9vcxz8765xlkj4321fdsa090",
    "vcxz8765xlkj4321fdsa0909"
  ];

  BlocSupervisor.delegate = DebugBlocDelegate();

  test('initializes correctly', () async {
    SharedPreferences.setMockInitialValues({
      DeviceIdBloc.DEVICE_ID_KEY: TEST_PRIMARY_ID,
      DeviceIdBloc.ALTERNATE_IDS_KEY: TEST_ALT_IDS
    });

    final bloc = DeviceIdBloc();
    bloc.listen(print);
    await expectLater(bloc,
        emitsThrough(DeviceIdLoadedState(TEST_PRIMARY_ID, TEST_ALT_IDS)));
  });

  group('DeviceCodeBloc', () {
    test('sets primary ID on InitializePrimaryId', () async {
      SharedPreferences.setMockInitialValues({
        DeviceIdBloc.DEVICE_ID_KEY: null,
        DeviceIdBloc.ALTERNATE_IDS_KEY: null
      });

      final bloc = DeviceIdBloc();

      // Wait for bloc to load from prefs
      await expectLater(bloc, emitsThrough(DeviceIdLoadedState(null, [])));

      bloc.add(DeviceIdInitializePrimaryEvent(TEST_PRIMARY_ID));

      // Make sure event was processed
      await expectLater(
          bloc, emitsThrough(DeviceIdLoadedState(TEST_PRIMARY_ID, [])));

      // Make sure changes were persisted
      SharedPreferences.getInstance().then(expectAsync1((prefs) {
        expect(prefs.getString(DeviceIdBloc.DEVICE_ID_KEY), TEST_PRIMARY_ID);
      }));
    });

    test('clears primary ID on DeletePrimaryId', () async {
      SharedPreferences.setMockInitialValues({
        DeviceIdBloc.DEVICE_ID_KEY: TEST_PRIMARY_ID,
        DeviceIdBloc.ALTERNATE_IDS_KEY: TEST_ALT_IDS
      });

      final bloc = DeviceIdBloc();

      // Wait for bloc to load from prefs
      await expectLater(bloc,
          emitsThrough(DeviceIdLoadedState(TEST_PRIMARY_ID, TEST_ALT_IDS)));

      bloc.add(DeviceIdDeletePrimaryEvent());

      // Make sure event was processed
      await expectLater(
          bloc, emitsThrough(DeviceIdLoadedState(null, TEST_ALT_IDS)));

      // Make sure changes were persisted
      SharedPreferences.getInstance().then(expectAsync1((prefs) {
        expect(prefs.getString(DeviceIdBloc.DEVICE_ID_KEY), null);
      }));
    });

    test('adds new alternate ID', () async {
      SharedPreferences.setMockInitialValues({
        DeviceIdBloc.DEVICE_ID_KEY: TEST_PRIMARY_ID,
        DeviceIdBloc.ALTERNATE_IDS_KEY: null
      });

      const NEW_ALTERNATE_ID = "cxz8765xlkj4321fdsa0909v";

      final bloc = DeviceIdBloc();
      bloc.idProvider = () => NEW_ALTERNATE_ID;

      // Wait for bloc to load from prefs
      await expectLater(
          bloc, emitsThrough(DeviceIdLoadedState(TEST_PRIMARY_ID, [])));

      bloc.add(DeviceIdGenerateAlternateEvent());

      // Make sure event was processed
      await expectLater(
          bloc,
          emitsThrough(
              DeviceIdLoadedState(TEST_PRIMARY_ID, [NEW_ALTERNATE_ID])));

      // Make sure changes were persisted
      SharedPreferences.getInstance().then(expectAsync1((prefs) {
        expect(prefs.getStringList(DeviceIdBloc.ALTERNATE_IDS_KEY),
            [NEW_ALTERNATE_ID]);
      }));
    });
  });
}
