package com.example.my_app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.EventChannel.EventSink
import com.example.my_app.SpotifyBroadcastReceiver
import com.example.my_app.EventStreamHandler
import android.content.IntentFilter
import android.os.Bundle
import android.content.BroadcastReceiver
import android.content.Context
import androidx.annotation.NonNull

class MainActivity : FlutterActivity() {
    private val CHANNEL = "method"
    private val EVENT = "track_change"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT).setStreamHandler(EventStreamHandler(context))

        }

    }

