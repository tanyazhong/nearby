import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_app/api.dart';
import 'package:spotify/spotify.dart';
import 'package:transparent_image/transparent_image.dart';



///Represents the page that will display a song
class Song extends StatefulWidget{
  final Track track;
  const Song({Key? key, required this.track}): super(key: key);

  @override
  ///Creates mutable state for Song at a given location in the tree
  _SongState createState() => _SongState( track: track);
}

///Class that holds the state of [Song] and displays the song page
class _SongState extends State<Song> {

  Track track;
  _SongState({ required this.track});
  String? imageUrl;

  ///Retrieves the url of the image of the designated track from the [API class]
  @override
  initState(){
    AlbumSimple album = track.album!;
    imageUrl = API().imageUrl(album);
    print('image url is $imageUrl');
  }

  ///Displays the list of artists
  Widget artistList() {
    List<Widget> list =  [];
    String? temp;
    int length = track.artists!.length;
    if (length == 0){
      return Text('Artist not available');
    }
    for (int i = 0; i< length; i++){
      if (i == length -1){
        temp = track.artists![i].name;
      }
      else{
        temp = track.artists![i].name! + ', ';
      }
      list.add(Text(temp!, style: TextStyle(fontFamily: 'Acme', fontSize: 20),));
    }
    return Row(children: list, mainAxisAlignment: MainAxisAlignment.center,);
   // return Row(children: track.artists!.map((artist) =>  Text('${artist.name}', style: GoogleFonts.acme(fontSize: 20),)).toList());
  }

  ///Displays the page and calls [artistList()]
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' ',
          style: TextStyle(color: Colors.black, fontSize: 35),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        centerTitle: true,
        toolbarHeight: 50,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child:
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    child:
                      FadeInImage.memoryNetwork(placeholder: kTransparentImage, image: imageUrl!),
              )),
              Text('${track.name}', style: TextStyle(fontFamily: 'Acme', fontSize: 30,), textAlign: TextAlign.center,),
              artistList(),
            ]

        ),
      ),
    );
  }
}


///Represents the page that will display a song
class SongWidget extends StatefulWidget{
  final String trackID;
  const SongWidget({Key? key, required this.trackID}): super(key: key);

  @override
  ///Creates mutable state for Song at a given location in the tree
  _SongWidgetState createState() => _SongWidgetState( trackID: trackID);
}

///Class that holds the state of [SongWidget] and displays the song page
class _SongWidgetState extends State<SongWidget> {

  String trackID;

  _SongWidgetState({ required this.trackID});


  ///Displays the list of artists
  Widget artistList(Track track) {
    if(track.name == null){
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
      }
      else {
        temp = track.artists![i].name! + ', ';
      }
      list.add(
          Text(temp!, style: TextStyle(fontFamily: 'Acme', fontSize: 10),));
    }
    return Row(children: list, mainAxisAlignment: MainAxisAlignment.center,);
  }

  ///Displays the page and calls [artistList()]
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: API()
            .authenticate()
            .tracks
            .get(trackID),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            Track track = snapshot.data;
            print('track is $track from builder');
            return GestureDetector(
              onTap: () {Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => Song(
                    track: track,
                    ),
                ));
                },
              child: Container(
              alignment: Alignment.center,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                        padding: EdgeInsets.all(20),
                        child:
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          child:
                          FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage, image: API().imageUrl(track.album!)),
                        )),
                    Text('${track.name}',
                      style: TextStyle(fontFamily: 'Acme', fontSize: 18,),
                      textAlign: TextAlign.center,),
                    artistList(track),
                  ]

              )
            ),
            );
          }
          else {
            return Center(
                   child: Text('Not available',
                      style: TextStyle(fontFamily: 'Acme', fontSize: 20,),
                      textAlign: TextAlign.center,),
                 // ]

             // ),
            );
          }
        }
    );
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

/*
void goToSongPage(SpotifyApi spotify, String songID) {
  Track? track;
  spotify.tracks.get(songID).then((value) {
    track = value;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Song(
          track: track!,
        ),
      ),
    );
  });
}
*/
