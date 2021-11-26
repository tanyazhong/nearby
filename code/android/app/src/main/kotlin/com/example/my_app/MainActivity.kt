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
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "try") {
                println("success")
                result.success(1)
            } else {
                println("failed")
            }
        }
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT).setStreamHandler(EventStreamHandler(context))

        }
    }

  // println("inside main activity")
  /* var eventStreamHandler: EventStreamHandler? = null
   override fun onCreate(savedInstanceState: Bundle?){
      super.onCreate(savedInstanceState)
       var flutterEngine = FlutterEngine(this)
      GeneratedPluginRegistrant.registerWith(flutterEngine)
      eventStreamHandler = EventStreamHandler()
      val channel = EventChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), "track_change")
      channel.setStreamHandler(eventStreamHandler)
   }*/


    /*override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine){
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        EventChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), "track_change").setStreamHandler(
             EventChannel.StreamHandler {
                 override fun onListen(arguments: Any?, eventSink: EventSink?) {
                     println("running onLIsten");
                     val receiver = SpotifyBroadcastReceiver();
                     receiver.setListener(object : SpotifyTrackChangeListener() {
                         override fun onTrackChange(trackID: String?) {
                             if (trackID != null) {
                                 println("success");
                                 eventSink!!.success(trackID);
                             }
                         }
                     })
                 }
             }
        override fun onCancel(p0: Any){

        }
        )
    }*/


    /*private var eventSink: EventSink? = null;
    //private lateinit var context: Context;

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        println("running configure flutter engine");
        super.configureFlutterEngine(flutterEngine);

        val eventChannel = EventChannel(flutterEngine.dartExecutor.binaryMessenger, "track_change");
        eventChannel.setStreamHandler(this);
      //  context = flutterEngine.applicationContext;
    }

    override fun onListen(arguments: Any?, eventSink: EventSink?){
        println("running onLIsten");
        val receiver = SpotifyBroadcastReceiver();
        receiver.setListener(object: SpotifyTrackChangeListener() {
            override fun onTrackChange(trackID: String?) {
                if (trackID != null) {
                    println("success");
                    eventSink!!.success(trackID);
                }
            }
            val filter = IntentFilter("com.spotify.music.metadatachanged");
          //  context.registerReceiver(receiver, filter);
        })

    }

    override fun onCancel(p0: Any){}

*/




