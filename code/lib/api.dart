import 'dart:async';


import 'package:spotify/spotify.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';

//https://pub.dev/documentation/uni_links/latest/ for uni_links

const String clientID = "b03425c1e1af4ba1bc82f71a5bc0875b";
const String clientSecret = "2bcdc8148d674bfa92507e10280971f4";

class API {
  var spotify;
  var credentials;
  AlbumSimple? album;
  bool currentlyPlayingBool = false;
  String? albumID;
  var currentTrack;

  /// Fetches a SpotifyAPI object using client and secret API keys.
  ///
  /// Returns a SpotifyApi object that can be used to fetch music data.
  /// Since this function takes in no arguments, it is implemented independently of other feature and used in isolation.
  /// This provides a modular way to validate a set of API credentials, and it can still be used in the same way in the case of changing requirements.
  /// For instance, if we wanted to use a different set of API credentials or authenticate through a different method, changes will be isolated to this file.
  /// We would not need to change any client classes.
  /// Other than its name, it also exposes very little to client classes -- a client class does not need to know how internal details are implemented to use.
  SpotifyApi authenticate() {
    credentials = SpotifyApiCredentials(clientID, clientSecret);
    spotify = SpotifyApi(credentials);
    return spotify;
  }

  /// Prompts a new page for users to authenticate with their Spotify account.
  ///
  /// Returns a SpotifyAPI object that can be used to read user data.
  /// This function takes in no arguments, so it is implemented independently of other features and used in isolation.
  /// This provides a modular way to validate a user with their Spotify account, and it can be used in the same way in the case of changing requirements.
  /// For instance, if we wanted to add 2 factor authentication or give authorized users specific privileges, we can just add that to the implementation without touching any client classes.
  /// Other than its name, it also exposes very little to client classes -- a client class does not need to know how internal details are implemented to use it.

  Future<SpotifyApi> authenticateUser() async {
    print('big authenticate');
    await _authenticateUser().then((value) {
      spotify = value;
    }, onError: (error) {
      print(error);
      spotify = SpotifyApi(credentials);
    });
    return spotify;
  }

  Future<SpotifyApi> _authenticateUser() async {
    print('trying to run api auth');
    credentials = SpotifyApiCredentials(clientID, clientSecret);
    spotify = SpotifyApi(credentials);
    print("passed");

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
      'playlist-modify-private',
      'user-read-recently-played'
    ];

    final authUri =
        grant.getAuthorizationUrl(Uri.parse(redirectUri), scopes: scopes);

    var result;
    await FlutterWebAuth.authenticate(
            url: authUri.toString(), callbackUrlScheme: "nearby")
        .then((value) {
      result = value;
    });
    final tokens = Uri.parse(result).queryParameters;
    var client = await grant.handleAuthorizationResponse(tokens);
    spotify = SpotifyApi.fromClient(client);
    return spotify;
  }

  /// Gets the most recently played songs.
  ///
  /// Returns an iterable list of PlayHistory objects of length [numSongs], representing the most recently played songs of a user.
  /// This function only takes in an argument of the number of PlayHistory objects to return, so it also supports modularity. Users
  /// do not need to know how these songs are retrieved to use the API, which is a feature of information hiding. Thus if our needs change,
  /// like we need to filter podcasts out, we can change this implementation without touching client classes.
  /// We also return them as an iterable list of PlayHistory, which is a data type defined by the Spotify Flutter API. This is the most
  /// flexible data type to use because it is the base data type. For instance, if we only wanted the song names or the song IDs, these fields
  /// are easily recoverable by reading fields of each PlayHistory in the client. Thus this adheres to the information hiding principle, as we
  /// wouldn't have to change the implementation.
  Future<Iterable<PlayHistory>> getRecentlyPlayed(int numSongs) async {
    return await spotify.me.recentlyPlayed(limit: numSongs);
  }

  /// Adds provided songs into a playlist.
  ///

  Future<Playlist> createPlaylist(Iterable<String> songURIs) async {
    var user = await spotify.me.get();
    Playlist newPlaylist = await spotify.playlists.createPlaylist(
      user.id!,
      'nEARby Playlist',
      description:
          'Autogenerated playlist with songs played near you, created by nEARby',
      public: false,
    );

    for (String uri in songURIs) {
      try {
        if (uri.startsWith("spotify:track:")) {
          await spotify.playlists.addTrack(uri, newPlaylist.id!);
        } else {
          // Need to prepend spotify URI info
          await spotify.playlists
              .addTrack("spotify:track:" + uri, newPlaylist.id!);
        }
      } on Exception catch (e) {
        print(e);
      }
    }

    return newPlaylist;
  }

  Future<Track> currentlyPlaying() async {
    await spotify.me.currentlyPlaying().then((Player? a) {
      if (a == null) {
        print('Nothing currently playing.');
        currentTrack =
            spotify.tracks.get('4pvb0WLRcMtbPGmtejJJ6y?si=c123ba3cb2274b8f');
        return currentTrack;
      }
      print('Currently playing: ${a.item?.name}');
      String? preview = a.item!.album!.images!.first.url;
      print('image is ${preview}');

      currentlyPlayingBool = true;
      album = a.item!.album;
      currentTrack = a.item!;
      print('assigned');
    }).catchError((error) {
      print('error status is $error');
      currentTrack =
          spotify.tracks.get('4pvb0WLRcMtbPGmtejJJ6y?si=c123ba3cb2274b8f');
    });
    return currentTrack;
  }

  Future<void> followingArtists(SpotifyApi spotify) async {
    var cursorPage = spotify.me.following(FollowingType.artist);
    await cursorPage.first().then((cursorPage) {
      print(cursorPage.items!.map((artist) => artist.name).join(', '));
    });
  }

  String imageUrl(AlbumSimple album) {
    String? url = album.images!.first.url;
    if (url == null) {
      return 'https://www.google.com/imgres?imgurl=https%3A%2F%2Fbitsofco.de%2Fcontent%2Fimages%2F2018%2F12%2FScreenshot-2018-12-16-at-21.06.29.png&imgrefurl=https%3A%2F%2Fbitsofco.de%2Fhandling-broken-images-with-service-worker%2F&tbnid=sqE6vb3PGP0sLM&vet=12ahUKEwizwuSTuYL0AhVFEFMKHbSsBewQMygLegUIARDHAQ..i&docid=xVwqYIVUdXUeHM&w=339&h=265&q=image%20not%20found&ved=2ahUKEwizwuSTuYL0AhVFEFMKHbSsBewQMygLegUIARDHAQ';
    } else {
      return url;
    }
  }

  Future<String> getProfileImage(String userID) async {
    UserPublic user = await spotify.users.get(userID);
    return user.images!.first.url!;
  }

  Future<String> getUserDisplayName(String userID) async {
    UserPublic user = await spotify.users.get(userID);
    return user.displayName!;
  }
}

