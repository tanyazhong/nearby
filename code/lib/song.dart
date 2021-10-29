import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uni_links/uni_links.dart';

const String clientID = "23d2ea2c69e74794b6390d74307a6812";
const String clientSecret = "5b342954dd284bb18625a596023d526b";

class Song extends StatefulWidget {
  @override
  _SongState createState() => _SongState();
}

class _SongState extends State<Song> {
  var spotify;
  var credentials;

  redirect(String authUri) async {
    print("redirecting");
    await launch(authUri, forceWebView: true);
  }

  Future<String> listen(redirectUri) async {
    String? responseUri = "empty string";
    responseUri = await linkStream.single;
    return responseUri!;
  }

  @override
  initState() {
    credentials = SpotifyApiCredentials(clientID, clientSecret);
    spotify = SpotifyApi(credentials);
    print("passed");
  }

  authenticate() async {
    final grant = SpotifyApi.authorizationCodeGrant(credentials);
    const redirectUri = 'https://spotify.com';
    final scopes = [
      'app-remote-control',
      'user-modify-playback-state',
      'user-read-private',
      'playlist-read-private',
      'playlist-modify-public',
      "playlist-read-collaborative",
      'user-read-currently-playing',
    ];

    final authUri =
        grant.getAuthorizationUrl(Uri.parse(redirectUri), scopes: scopes);

    print(authUri.toString());
    await redirect(authUri.toString());
    String responseUri = await listen(redirectUri);

    print(responseUri);
    var client = await grant
        .handleAuthorizationResponse(Uri.parse(responseUri).queryParameters);
    spotify = SpotifyApi.fromClient(client);
    print("passed2");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Song'),
      ),
      body: Center(
        child: Column(children: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("go back")),
          TextButton(
            onPressed: () async {
              var album = await spotify.albums.get('1NAmidJlEaVgA3MpcPFYGq?si');
              print(album.name);
              //doesn't work, no user
              authenticate();
              //var currently = await spotify.me.currentlyPlaying();
              // print(currently);
            },
            child: Text("press for api call"),
          )
        ]),
      ),
    );
  }
}

//https://open.spotify.com/track/1dGr1c8CrMLDpV6mPbImSI?si=066eca5b3d534656  lover song
//https://open.spotify.com/album/1NAmidJlEaVgA3MpcPFYGq?si=DgZmYX14RL2ANQDnd2Vidw
