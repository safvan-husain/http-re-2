package com.starkin.recovery224

import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import android.provider.Settings
import android.content.ContentResolver

class MainActivity: FlutterActivity() {
    private val CHANNEL = "androidId"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            // Note: this method is invoked on the main thread.
            call, result ->
            if (call.method == "getId") {
                val androidId = Settings.Secure.getString(contentResolver, Settings.Secure.ANDROID_ID)
                println("Android ID: $androidId")

                if (androidId != null) {
                    result.success(androidId)
                } else {
                    result.error("UNAVAILABLE", "Andorid Id not available.", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}