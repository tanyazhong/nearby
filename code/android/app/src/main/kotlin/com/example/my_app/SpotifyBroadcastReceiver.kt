package com.example.my_app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent



abstract class SpotifyTrackChangeListener{
    abstract fun onTrackChange(trackID : String?);
}

class SpotifyBroadcastReceiver : BroadcastReceiver() {
    private lateinit var callback: SpotifyTrackChangeListener
    override fun onReceive(context: Context, intent: Intent){
        println("intent.action is ${intent?.action}");
        if(intent != null && intent?.action == "com.spotify.music.metadatachanged"){
            callback.onTrackChange(intent?.getStringExtra("id"));
        }
    }
    fun setListener(callback: SpotifyTrackChangeListener){
        println("runnong setListener");
        this.callback = callback;

    }

}
