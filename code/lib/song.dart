import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';

const String clientID = "b03425c1e1af4ba1bc82f71a5bc0875b";
const String clientSecret = "2bcdc8148d674bfa92507e10280971f4";

class Song extends StatefulWidget{
  @override
  _SongState createState() => _SongState();
}

class _SongState extends State<Song> {

  var spotify;

  @override
  initState() {
    SpotifyApiCredentials credentials = SpotifyApiCredentials(
        clientID, clientSecret);
    spotify = SpotifyApi(credentials);
    print("passed");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Song'),
      ),
        body: Center(
          child: Column(
              children:[
                TextButton(onPressed: () {
                  Navigator.pop(context);
                }, child: Text("go back")),
                TextButton(onPressed: () async {
                  var album = await spotify.albums.get('1NAmidJlEaVgA3MpcPFYGq?si');
                  print(album.name);
                  //doesn't work, no user
                  var currently = await spotify.me.currentlyPlaying();
                  print(currently);
                },
                child: Text("press for api call"),)
              ]

    ),
    ),

    );
  }
}

//https://open.spotify.com/track/1dGr1c8CrMLDpV6mPbImSI?si=066eca5b3d534656  lover song
//https://open.spotify.com/album/1NAmidJlEaVgA3MpcPFYGq?si=DgZmYX14RL2ANQDnd2Vidw

