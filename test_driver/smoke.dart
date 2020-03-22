import 'package:flutter_driver/driver_extension.dart';
import 'package:zerobase_app/main.dart' as main;

// https://github.com/flutter/website/blob/master/src/docs/cookbook/testing/integration/introduction.md

void setup() {
	// This line enables the extension.
	enableFlutterDriverExtension();

	// Call the `main()` function of the app, or call `runApp` with
	// any widget you are interested in testing.
	main.main();
}