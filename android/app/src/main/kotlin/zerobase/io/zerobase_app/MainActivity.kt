package zerobase.io.zerobase_app

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import com.microsoft.appcenter.AppCenter
import com.microsoft.appcenter.crashes.Crashes

// This is not a secret and doesn't need to be secured.
const val APP_CENTER_KEY = "3e6478d5-a616-43cc-a4d1-bcd4f3565936"

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        AppCenter.start(getApplication(), APP_CENTER_KEY, Crashes::class.java)
    }
}
