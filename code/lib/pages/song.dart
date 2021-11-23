import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_app/api.dart';
import 'package:spotify/spotify.dart';
import 'package:transparent_image/transparent_image.dart';

abstract class SongState extends State<StatefulWidget> {
  ///Song ID that can be used with the spotify API to get the song's track, set in constructor
  String trackID;
  double fontSize;

  SongState({required this.trackID, required this.fontSize});

  Widget build(BuildContext context);
  void onTap();

  ///Displays the list of artists
  Widget artistList(Track track) {
    if (track.name == null) {
      return Text('Artist not available');
    }
    List<Widget> list = [];
    String? temp;
    int length = track.artists!.length;
    if (length == 0) {
      return Text('Artist not available');
    }
    for (int i = 0; i < length; i++) {
      if (i == length - 1) {
        temp = track.artists![i].name;
      } else {
        temp = track.artists![i].name! + ', ';
      }
      list.add(Text(
        temp!,
        style: TextStyle(fontFamily: 'Acme', fontSize: fontSize),
      ));
    }
    return Row(
      children: list,
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  Widget songContainer() {
    return FutureBuilder(
        future: API().authenticate().tracks.get(trackID),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            Track track = snapshot.data;
            print('track is $track from builder');
            return GestureDetector(
              onTap: onTap,
              child: Container(
                  alignment: Alignment.center,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                            padding: EdgeInsets.all(20),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              child: FadeInImage.memoryNetwork(
                                  placeholder: kTransparentImage,
                                  image: API().imageUrl(track.album!)),
                            )),
                        Text(
                          '${track.name}',
                          style: TextStyle(
                            fontFamily: 'Acme',
                            fontSize: fontSize + 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        artistList(track),
                      ])),
            );
          } else {
            return Center(
              child: Text(
                'Loading...',
                style: TextStyle(
                  fontFamily: 'Acme',
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }
        });
  }
}

///Represents the page that will display a song
class SongPage extends StatefulWidget {
  ///Track of the song that will be displayed, holds image url, artist names and song name, set in constructor
  final String trackID;

  const SongPage({Key? key, required this.trackID}) : super(key: key);

  @override

  ///Creates mutable state for Song at a given location in the tree
  _SongPageState createState() =>
      _SongPageState(trackID: trackID, fontSize: 20);
}

///Class that holds the state of [Song] and displays the song page
class _SongPageState extends SongState {
  ///Track of the song that will be displayed, holds image url, artist names and song name, set in constructor

  String? imageUrl;
  String trackID;
  double fontSize;
  _SongPageState({required this.trackID, required this.fontSize})
      : super(trackID: trackID, fontSize: fontSize);

  void onTap() {}

  ///Displays the page and calls [artistList()]
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ' ',
          style: TextStyle(color: Colors.black, fontSize: 35),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        centerTitle: true,
        toolbarHeight: 50,
      ),
      body: songContainer(),
    );
  }
}

///Represents the page that will display a song
class SongWidget extends StatefulWidget {
  ///Song ID that can be used with the spotify API to get the song's track, set in contstructor
  final String trackID;

  const SongWidget({Key? key, required this.trackID}) : super(key: key);

  @override

  ///Creates mutable state for Song at a given location in the tree
  _SongWidgetState createState() =>
      _SongWidgetState(trackID: trackID, fontSize: 10);
}

///Class that holds the state of [SongWidget] and displays the song page
class _SongWidgetState extends SongState {
  ///Song ID that can be used with the spotify API to get the song's track, set in constructor
  String trackID;
  double fontSize;

  _SongWidgetState({required this.trackID, required this.fontSize})
      : super(trackID: trackID, fontSize: fontSize);

  void onTap() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SongPage(
            trackID: trackID,
          ),
        ));
  }

  ///Displays the page and calls [artistList()]
  @override
  Widget build(BuildContext context) {
    return songContainer();
  }
}

///Represents the page that will display a song
class ListSongWidget extends StatefulWidget {
  ///Song ID that can be used with the spotify API to get the song's track, set in contstructor
  final String trackID;

  const ListSongWidget({Key? key, required this.trackID}) : super(key: key);

  @override

  ///Creates mutable state for Song at a given location in the tree
  _ListSongWidgetState createState() =>
      _ListSongWidgetState(trackID: trackID, fontSize: 10);
}

///Class that holds the state of [ListSongWidget] and displays the song page
class _ListSongWidgetState extends SongState {
  ///Song ID that can be used with the spotify API to get the song's track, set in constructor
  String trackID;
  double fontSize;

  _ListSongWidgetState({required this.trackID, required this.fontSize})
      : super(trackID: trackID, fontSize: fontSize);

  void onTap() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SongPage(
            trackID: trackID,
          ),
        ));
  }

  ///Displays the page and calls [artistList()]
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: API().authenticate().tracks.get(trackID),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            Track track = snapshot.data;
            print('track is $track from builder');
            return GestureDetector(
              onTap: onTap,
              child: Container(
                  alignment: Alignment.center,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                            padding: EdgeInsets.all(20),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              child: FadeInImage.memoryNetwork(
                                  placeholder: kTransparentImage,
                                  image: API().imageUrl(track.album!)),
                            )),
                        Text(
                          '${track.name}',
                          style: TextStyle(
                            fontFamily: 'Acme',
                            fontSize: fontSize + 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        artistList(track),
                      ])),
            );
          } else {
            return const Center(
              child: Text(
                'Loading...',
                style: TextStyle(
                  fontFamily: 'Acme',
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }
        });
  }
}






/*
void getCurrentTrack()  {
  print('entering getcurrentrack, spotify is $spotify');
  if (apiInstance == null){
    print('api null');
  }
  apiInstance!.currentlyPlaying().then((value){
    print('inside then');
    setState(() {
      track = value;
      Navigator.push(context, MaterialPageRoute(builder: (_) => Song(spotify: spotify!, track: track!,),),);
    });
    print( 'track is $track');
  });
  print('returning from getCurrentTrack');
}
*/


