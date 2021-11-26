package com.example.my_app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

fun createBroadCast(context: Context){
    Intent().also { intent ->
        intent.action = "action.track_change"
        intent.putExtra("id", "123")
        context.sendBroadcast(intent)
    }
}

abstract class SpotifyTrackChangeListener{
    abstract fun onTrackChange(trackID : String?);
}

public class SpotifyBroadcastReceiver : BroadcastReceiver() {
    private lateinit var callback: SpotifyTrackChangeListener
    fun setListener(callback: SpotifyTrackChangeListener){
        println("runnong setListener");
        this.callback = callback;
    }
    override fun onReceive(context: Context?, intent: Intent?){
        println("intent.action is ${intent?.action}");
       if(intent != null && intent?.action == "action.track_change"){
            callback.onTrackChange(intent?.getStringExtra("id"));
       }
    }
}
