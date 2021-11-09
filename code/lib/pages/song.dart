import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_app/api.dart';
import 'package:spotify/spotify.dart';
import 'package:transparent_image/transparent_image.dart';




class Song extends StatefulWidget{
  final Track track;
  const Song({Key? key, required this.track}): super(key: key);

  @override
  _SongState createState() => _SongState( track: track);
}

class _SongState extends State<Song> {

  Track track;
  _SongState({ required this.track});
  String? imageUrl;

  @override
  initState(){
    AlbumSimple album = track.album!;
    imageUrl = API().imageUrl(album);
    print('image url is $imageUrl');
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Song'),
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
