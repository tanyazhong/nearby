import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spotify/spotify.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';


//https://pub.dev/documentation/uni_links/latest/ for uni_links
const String clientID = "b03425c1e1af4ba1bc82f71a5bc0875b";
const String clientSecret = "2bcdc8148d674bfa92507e10280971f4";

class API  {


  var spotify;
  var credentials;
  AlbumSimple? album;
  bool currentlyPlayingBool = false;
  String? albumID;
  var currentTrack;



  SpotifyApi authenticate() {
    print('big authenticate');
    _authenticate().then((value){
      spotify = value;
    },onError: (error){
      print(error);
      spotify = SpotifyApi(credentials);
    });
    return spotify;
  }

  Future<SpotifyApi> _authenticate() async  {
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
      'playlist-modify-private'
    ];

    final authUri =
    grant.getAuthorizationUrl(Uri.parse(redirectUri), scopes: scopes);

    var result;
    await FlutterWebAuth.authenticate(
        url: authUri.toString(), callbackUrlScheme: "nearby").then((value){
          result = value;
    });
    final tokens = Uri
        .parse(result)
        .queryParameters;
    var client = await grant.handleAuthorizationResponse(tokens);
    spotify = SpotifyApi.fromClient(client);
    return spotify;
  }

    Future<Track> _currentlyPlaying( SpotifyApi spotify) async {
    Track? track;
    print('beofre calling _current');
    await _currentlyPlaying(spotify);
    print('moved on, current track is $currentTrack');
    if(currentTrack == null){
      spotify.tracks.get('4pvb0WLRcMtbPGmtejJJ6y?si=c123ba3cb2274b8f').then((value){
        track = value;
        print('null track is $track');
      });
    }else{
      track = currentTrack;
    }
    print('returning from currentlyPlaying, track is $track');
    return track!;
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
      currentTrack = spotify.tracks.get('4pvb0WLRcMtbPGmtejJJ6y?si=c123ba3cb2274b8f');
    });
    return currentTrack;
  }


    Future<void> devices(SpotifyApi spotify) async {
      await spotify.me.devices().then((Iterable<Device>? devices) {
        if (devices == null) {
          print('No devices currently playing.');
          return;
        }
        print('Listing ${devices.length} available devices:');
        print(devices.map((device) => device.name).join(', '));
      });
    }
    Future<void> followingArtists(SpotifyApi spotify) async {
      var cursorPage = spotify.me.following(FollowingType.artist);
      await cursorPage.first().then((cursorPage) {
        print(cursorPage.items!.map((artist) => artist.name).join(', '));
      });
    }


    String imageUrl(AlbumSimple album){
      print('called in imageurl');
      String? url = album.images!.first.url;
      if (url == null){
        return 'https://www.google.com/imgres?imgurl=https%3A%2F%2Fbitsofco.de%2Fcontent%2Fimages%2F2018%2F12%2FScreenshot-2018-12-16-at-21.06.29.png&imgrefurl=https%3A%2F%2Fbitsofco.de%2Fhandling-broken-images-with-service-worker%2F&tbnid=sqE6vb3PGP0sLM&vet=12ahUKEwizwuSTuYL0AhVFEFMKHbSsBewQMygLegUIARDHAQ..i&docid=xVwqYIVUdXUeHM&w=339&h=265&q=image%20not%20found&ved=2ahUKEwizwuSTuYL0AhVFEFMKHbSsBewQMygLegUIARDHAQ';
      }
      else {
        return url;
      }
    }



}

//https://open.spotify.com/track/1dGr1c8CrMLDpV6mPbImSI?si=066eca5b3d534656  lover song
//https://open.spotify.com/album/1NAmidJlEaVgA3MpcPFYGq?si=DgZmYX14RL2ANQDnd2Vidw
