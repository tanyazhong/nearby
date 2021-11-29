import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_app/api.dart';
import 'package:spotify/spotify.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:my_app/pages/profile_page.dart';

abstract class SongState extends State<StatefulWidget> {
  ///Song ID that can be used with the spotify API to get the song's track, set in constructor
  String trackID;
  double fontSize;
  String userID;
  SongState(
      {required this.trackID, required this.fontSize, required this.userID});

  Widget build(BuildContext context);
  void onTap();

  ///Displays the list of artists
  Widget artistList(Track track, {bool alignLeft = false}) {
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
        style: TextStyle(
          fontFamily: 'Acme',
          fontSize: fontSize,
          overflow: TextOverflow.ellipsis,
        ),
      ));
    }
    if (alignLeft) {
      return Row(
        children: list,
        mainAxisAlignment: MainAxisAlignment.start,
      );
    }
    return Column(
      children: list,
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  Widget songContainer(bool overflow) {
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
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          child: FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image: API().imageUrl(track.album!)),
                        ),
                        Text(
                          '${track.name}',
                          style: TextStyle(
                            fontFamily: 'Acme',
                            fontSize: fontSize + 10,
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                        artistList(track),
                      ]),
                ),
              ),
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

///Represents the page that will display a song
class SongPage extends StatefulWidget {
  ///Track of the song that will be displayed, holds image url, artist names and song name, set in constructor
  final String trackID;
  final String userID;
  const SongPage({Key? key, required this.trackID, required this.userID})
      : super(key: key);

  @override

  ///Creates mutable state for Song at a given location in the tree
  _SongPageState createState() =>
      _SongPageState(trackID: trackID, fontSize: 20, userID: userID);
}

///Class that holds the state of [Song] and displays the song page
class _SongPageState extends SongState {

  ///Track of the song that will be displayed, holds image url, artist names and song name, set in constructor
  String? imageUrl;
  String trackID;
  double fontSize;
  String userID;
  _SongPageState(
      {required this.trackID, required this.fontSize, required this.userID})
      : super(trackID: trackID, fontSize: fontSize, userID: userID);

  void onTap() {}

  ///Displays the page and calls [artistList()]
  @override
  Widget build(BuildContext context) {
    final icon = CupertinoIcons.profile_circled;
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            ' ',
            style: TextStyle(color: Colors.black, fontSize: 35),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,
          centerTitle: true,
          toolbarHeight: 50,
          actions: [
            IconButton(
                icon: Icon(icon),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context) {
                      return ProfilePage(
                        userID: userID,
                      );
                    },
                  ));
                }),
          ]),
      body: songContainer(false),
    );
  }
}

///Represents the page that will display a song
class SongWidget extends StatefulWidget {
  ///Song ID that can be used with the spotify API to get the song's track, set in contstructor
  final String trackID;
  final String userID;
  const SongWidget({Key? key, required this.trackID, required this.userID})
      : super(key: key);

  @override

  ///Creates mutable state for Song at a given location in the tree
  _SongWidgetState createState() =>
      _SongWidgetState(trackID: trackID, fontSize: 10, userID: userID);
}

///Class that holds the state of [SongWidget] and displays the song page
class _SongWidgetState extends SongState {
  ///Song ID that can be used with the spotify API to get the song's track, set in constructor
  String trackID;
  double fontSize;
  String userID;
  _SongWidgetState(
      {required this.trackID, required this.fontSize, required this.userID})
      : super(trackID: trackID, fontSize: fontSize, userID: userID);

  void onTap() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SongPage(trackID: trackID, userID: userID),
        ));
  }

  ///Displays the page and calls [artistList()]
  @override
  Widget build(BuildContext context) {
    return songContainer(true);
  }
}

///Represents the page that will display a song
class ListSongWidget extends StatefulWidget {
  ///Song ID that can be used with the spotify API to get the song's track, set in contstructor
  final String trackID;
  final String userID;
  const ListSongWidget({Key? key, required this.trackID, required this.userID})
      : super(key: key);

  @override

  ///Creates mutable state for Song at a given location in the tree
  _ListSongWidgetState createState() =>
      _ListSongWidgetState(trackID: trackID, fontSize: 10, userID: userID);
}

///Class that holds the state of [ListSongWidget] and displays the song page
class _ListSongWidgetState extends SongState {
  ///Song ID that can be used with the spotify API to get the song's track, set in constructor
  String trackID;
  double fontSize;
  String userID;
  _ListSongWidgetState(
      {required this.trackID, required this.fontSize, required this.userID})
      : super(trackID: trackID, fontSize: fontSize, userID: userID);

  void onTap() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SongPage(trackID: trackID, userID: userID),
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
            debugPrint('track is $track from builder');
            return GestureDetector(
                onTap: onTap,
                child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      child: FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: API().imageUrl(track.album!)),
                    ),
                    title: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${track.name}',
                            style: TextStyle(
                              fontFamily: 'Acme',
                              fontSize: fontSize + 12,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          artistList(track, alignLeft: true),
                        ])));
          } else {
            return const Center(
              child: Text(
                'Loading...',
                style: TextStyle(
                  fontFamily: 'Acme',
                  fontSize: 20,
                ),
                textAlign: TextAlign.left,
              ),
            );
          }
        });
  }
}