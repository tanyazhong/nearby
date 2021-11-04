import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spotify/spotify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uni_links/uni_links.dart';


//https://pub.dev/documentation/uni_links/latest/ for uni_links
const String clientID = "b03425c1e1af4ba1bc82f71a5bc0875b";
const String clientSecret = "2bcdc8148d674bfa92507e10280971f4";
const String redirectURI = "com.example.nearby://callback/success";
final scopes = ["user-read-email", "user-library-read"];

class Song extends StatefulWidget{
  @override
  _SongState createState() => _SongState();
}

class _SongState extends State<Song> {

  SpotifyApiCredentials? credentials;
  var spotify;
  String? responseURI = null;
  StreamSubscription? subscription;
  bool checkedInitialUri = false;
  String? currentLink;

  @override
  initState() {
    super.initState();
    credentials = SpotifyApiCredentials(
        clientID, clientSecret);
    spotify = SpotifyApi(credentials!);
    print("passed spotify credentials, no user yet");
    initialLink();
    print('passed initial uri link');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    subscription!.cancel();
  }
  //checks the initial uri link, called on initState
  void initialLink() async {
    if(!checkedInitialUri){
      checkedInitialUri = true;
      try {
        final link = await getInitialLink();
        if(link == null){
          print("no initial link");
        }
        else{
          print("initial link is $link");
        }
        if(!mounted) return;
        setState(() {
          currentLink = link;
        });
      }on PlatformException{
        print("failed to get initial link");
      }on FormatException catch (err){
        if (!mounted) return;
        print('malformed initial link');
      }
    }
  }

  void connectToUser() async{
    final grant = SpotifyApi.authorizationCodeGrant(credentials!);
    final authUri = grant.getAuthorizationUrl(Uri.parse(redirectURI), scopes: scopes,);
    print("authrui is ${authUri.toString()}");
    //opens browser to take user to spotify authorization page

    final result = await canLaunch((authUri.toString()));
    print('result is $result');
    if (await canLaunch(authUri.toString())){
      print("can launch");
      launch(authUri.toString());

    }
    print("passed canlaunch");
    //listen for redirection back to app from authorization page
    subscription = linkStream.listen((String? link){
      print("current link is $currentLink");
      if (link!.startsWith(redirectURI)){
        setState(() {
          currentLink = link;
        });
         print("success");
      }
      }, onError: (err){
        print("error listening to redirect");
     });
    print("passed listen");
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
                  child: Text("press for api call"),),
                TextButton(onPressed: () async {
                  connectToUser();
                },
                  child: Text("user log in"),),
              ]

    ),
    ),

    );
  }
}

//https://open.spotify.com/track/1dGr1c8CrMLDpV6mPbImSI?si=066eca5b3d534656  lover song
//https://open.spotify.com/album/1NAmidJlEaVgA3MpcPFYGq?si=DgZmYX14RL2ANQDnd2Vidw

