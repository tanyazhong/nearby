package com.example.my_app
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.EventChannel.StreamHandler
import android.content.Context
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.BinaryMessenger
import com.example.my_app.SpotifyBroadcastReceiver
import android.content.IntentFilter

/*
class EventChannelHandler(val context: Context){
    private lateinit var eventChannel: EventChannel

   fun startListening(messenger: BinaryMessenger?){
       println("startListening")
       eventChannel = EventChannel(messenger, "track_change");
       eventChannel.setStreamHandler( EventStreamHandler())

                   *//*override fun onListen(arguments: Any?, eventSink: EventSink){
                       println("onListen");
                       val receiver = SpotifyBroadcastReceiver();
                       receiver.setListener(object: SpotifyTrackChangeListener() {
                           override fun onTrackChange(trackID: String?) {
                               if (trackID != null) {
                                  println("success");
                                   eventSink.success(trackID);
                               }
                           }
                       })
                       val filter = IntentFilter("action.track_change");
                       context.registerReceiver(receiver, filter);
                   }

                   override fun onCancel(p0: Any){}*//*


   }

}*/

class EventStreamHandler : EventChannel.StreamHandler{
    private var eventSink: EventChannel.EventSink? = null

    override fun onListen(arguments: Any?, eventSink: EventChannel.EventSink?) {
        println("onListen")
        this.eventSink = eventSink;
        /*val receiver = SpotifyBroadcastReceiver()
        receiver.setListener(object : SpotifyTrackChangeListener() {
            override fun onTrackChange(trackID: String?) {
                if (trackID != null) {
                    println("success");
                    eventSink!!.success(trackID);
                }
            }
        })
*/
    }
    override fun onCancel(p0: Any){}
}
