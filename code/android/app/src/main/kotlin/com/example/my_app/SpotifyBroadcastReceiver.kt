package com.example.my_app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

fun createBroadCast(context: Context){
    println("createbroadcast")
    Intent().also { intent ->
        intent.action = "com.spotify.music.metadatachanged"
        intent.putExtra("id", "123")
        context.sendBroadcast(intent)
    }
}

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
    https://open.spotify.com/track/027269uzraETHuoG6aMs6a?si=1597b8fc1d5f45de
}
