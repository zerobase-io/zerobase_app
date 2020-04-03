import 'package:flutter_driver/driver_extension.dart';
import 'package:zerobase_app/main.dart' as app;

// https://github.com/flutter/website/blob/master/src/docs/cookbook/testing/integration/introduction.md

void main() {
	// This line enables the extension.
	enableFlutterDriverExtension();

	// Call the `main()` function of the app, or call `runApp` with
	// any widget you are interested in testing.
	app.main();
}