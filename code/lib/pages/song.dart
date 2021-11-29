import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_app/api.dart';
import 'package:spotify/spotify.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:my_app/pages/profile_page.dart';

///Abstract class that is implemented by all of the widgets and pages that display a track image, title and artist list
abstract class SongState extends State<StatefulWidget> {

  ///Song ID that can be used with the spotify API to get the song's track, set in constructor
  String trackID;

  ///Size of text font, implemented differently in different subclasses
  double fontSize;
  ///Associated with each track, used to display the profile page
  String userID;

  SongState(
      {required this.trackID, required this.fontSize, required this.userID});

  ///Abstract function that displays the various elements collected in the class\n
  ///Takes in BuildContext by default and returns a Widget
  Widget build(BuildContext context);

  ///Abstract function that determines what happens when the image is clicked on
  ///Takes nothing and returns nothing
  void onTap();

  ///Displays the list of artists
  ///Takes the Track that contains the list of artists and returns a Widget
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

  ///Displays the image, track title and artist list, calls [artistList()]
  ///Takes nothing and returns a Widget
  Widget songContainer() {
    return FutureBuilder(
        future: API().authenticate().tracks.get(trackID),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            Track track = snapshot.data;
            // print('track is $track from builder');
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

  ///Track ID of the song that will be displayed, holds image url, artist names and song name
  final String trackID;
  ///Associated with each track, used to display the profile page
  final String userID;

  const SongPage({Key? key, required this.trackID, required this.userID})
      : super(key: key);

  @override

  ///Creates mutable state for SongPage at a given location in the widget tree
  ///Takes nothing and returns an instance of _SongPageState
  _SongPageState createState() =>
      _SongPageState(trackID: trackID, fontSize: 20, userID: userID);
}

///Class that holds the state of [Song] and displays the song page
class _SongPageState extends SongState {

  ///Url of the track album image
  String? imageUrl;
  ///Track of the song that will be displayed, holds image url, artist names and song name, set in constructor
  String trackID;
  ///Size of text
  double fontSize;
  ///Associated with each track, used to display the profile page
  String userID;

  _SongPageState(
      {required this.trackID, required this.fontSize, required this.userID})
      : super(trackID: trackID, fontSize: fontSize, userID: userID);

  ///Is called when the image is clicked on, does nothing
  ///Takes and returns nothing
  void onTap() {}

  ///Displays the page and calls [songContainer(), onTap()]
  ///Takes the context and returns a Widget
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
      body: songContainer(),
    );
  }
}

///Represents the widget used in Grid view
class SongWidget extends StatefulWidget {

  ///Track ID of the song that will be displayed, holds image url, artist names and song name
  final String trackID;
  ///Associated with each track, used to display the profile page
  final String userID;

  const SongWidget({Key? key, required this.trackID, required this.userID})
      : super(key: key);

  @override
  ///Creates mutable state for [SongWidget] at a given location in the widget tree
  _SongWidgetState createState() =>
      _SongWidgetState(trackID: trackID, fontSize: 10, userID: userID);
}

///Class that holds the state of [SongWidget] and displays the song page
class _SongWidgetState extends SongState {

  ///Track ID of the song that will be displayed, holds image url, artist names and song name
  String trackID;
  ///Size of text
  double fontSize;
  ///Associated with each track, used to display the profile page
  String userID;
  _SongWidgetState(
      {required this.trackID, required this.fontSize, required this.userID})
      : super(trackID: trackID, fontSize: fontSize, userID: userID);

  ///Is called when the image is clicked on, pushes the SongPage to the top of the Navigation stack
  ///Takes and returns nothing
  void onTap() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SongPage(trackID: trackID, userID: userID),
        ));
  }

  ///Displays the page and calls [songContainer()]
  @override
  Widget build(BuildContext context) {
    return songContainer();
  }
}

///Represents the widget that is used in List view
class ListSongWidget extends StatefulWidget {

  ///Track ID of the song that will be displayed, holds image url, artist names and song name
  final String trackID;
  ///Associated with each track, used to display the profile page
  final String userID;

  const ListSongWidget({Key? key, required this.trackID, required this.userID})
      : super(key: key);

  @override
  ///Creates mutable state for [ListSongWidget] at a given location in the widget tree
  _ListSongWidgetState createState() =>
      _ListSongWidgetState(trackID: trackID, fontSize: 10, userID: userID);
}

///Class that holds the state of [ListSongWidget] and displays the song page
class _ListSongWidgetState extends SongState {
  ///Track ID of the song that will be displayed, holds image url, artist names and song name
  String trackID;
  ///Text size
  double fontSize;
  ///Associated with each track, used to display the profile page
  String userID;
  _ListSongWidgetState(
      {required this.trackID, required this.fontSize, required this.userID})
      : super(trackID: trackID, fontSize: fontSize, userID: userID);

  ///Is called when the image is clicked on, pushes the SongPage to the top of the Navigation stack
  ///Takes and returns nothing
  void onTap() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SongPage(trackID: trackID, userID: userID),
        ));
  }

  ///Displays the page and calls [songContainer(), artistList()]
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: API().authenticate().tracks.get(trackID),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            Track track = snapshot.data;
            // debugPrint('track is $track from builder');
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
