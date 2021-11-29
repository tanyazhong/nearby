package com.example.my_app
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.EventChannel.StreamHandler
import android.content.Context
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.BinaryMessenger
import com.example.my_app.SpotifyBroadcastReceiver
import android.content.IntentFilter



class EventStreamHandler(val context:Context) : EventChannel.StreamHandler{
    private var eventSink: EventChannel.EventSink? = null

    override fun onListen(arguments: Any?, eventSink: EventChannel.EventSink?) {
        this.eventSink = eventSink;
        val receiver = SpotifyBroadcastReceiver()
        receiver.setListener(object : SpotifyTrackChangeListener() {
            override fun onTrackChange(trackID: String?) {
                if (trackID != null) {
                    println("success");
                    eventSink!!.success(trackID);
                }
            }
        })
        val filter = IntentFilter("com.spotify.music.metadatachanged")
        context.registerReceiver(receiver, filter)
    }
    override fun onCancel(p0: Any){
    }
}
