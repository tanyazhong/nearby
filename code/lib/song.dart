import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uni_links/uni_links.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';

const String clientID = "b03425c1e1af4ba1bc82f71a5bc0875b";
const String clientSecret = "2bcdc8148d674bfa92507e10280971f4";

class Song extends StatefulWidget {
  @override
  _SongState createState() => _SongState();
}

class _SongState extends State<Song> {
  var spotify;
  var credentials;

  @override
  initState() {
    credentials = SpotifyApiCredentials(clientID, clientSecret);
    spotify = SpotifyApi(credentials);
    print("passed");
  }

  authenticate() async {
    final grant = SpotifyApi.authorizationCodeGrant(credentials);
    const redirectUri = 'nearby:/';
    final scopes = [
      'app-remote-control',
      'user-modify-playback-state',
      'user-read-private',
      'playlist-read-private',
      'playlist-modify-public',
      "playlist-read-collaborative",
      'user-read-currently-playing',
      'user-read-playback-state',
      'user-follow-read',
      'playlist-modify-private'
    ];

    final authUri =
        grant.getAuthorizationUrl(Uri.parse(redirectUri), scopes: scopes);

    final result = await FlutterWebAuth.authenticate(
        url: authUri.toString(), callbackUrlScheme: "nearby");
    final tokens = Uri.parse(result).queryParameters;
    var client = await grant.handleAuthorizationResponse(tokens);
    spotify = SpotifyApi.fromClient(client);
  }

  Future<void> _currentlyPlaying(SpotifyApi spotify) async =>
      await spotify.me.currentlyPlaying().then((Player? a) {
        if (a == null) {
          print('Nothing currently playing.');
          return;
        }
        print('Currently playing: ${a.item?.name}');
      });

  Future<void> _devices(SpotifyApi spotify) async =>
      await spotify.me.devices().then((Iterable<Device>? devices) {
        if (devices == null) {
          print('No devices currently playing.');
          return;
        }
        print('Listing ${devices.length} available devices:');
        print(devices.map((device) => device.name).join(', '));
      });

  Future<void> _followingArtists(SpotifyApi spotify) async {
    var cursorPage = spotify.me.following(FollowingType.artist);
    await cursorPage.first().then((cursorPage) {
      print(cursorPage.items!.map((artist) => artist.name).join(', '));
    });
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
              await authenticate();
              await _currentlyPlaying(spotify);
              await _devices(spotify);
              await _followingArtists(spotify);
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
