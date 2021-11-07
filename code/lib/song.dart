import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_app/api.dart';
import 'package:spotify/spotify.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:google_fonts/google_fonts.dart';



class Song extends StatefulWidget{
  final SpotifyApi spotify;
  final Track track;
  const Song({Key? key, required this.spotify, required this.track}): super(key: key);

  @override
  _SongState createState() => _SongState(spotify: spotify, track: track);
}

class _SongState extends State<Song> {

  SpotifyApi spotify;
  Track track;
  _SongState({required this.spotify, required this.track});
  String? imageUrl;

  @override
  initState(){
    AlbumSimple album = track.album!;
    imageUrl = API().imageUrl(album);
    print('image url is $imageUrl');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Song'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                child:
                  FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage, image: imageUrl!),
              ),
              Text('${track.name}', style: GoogleFonts.acme()),
            ]

        ),
      ),
    );
  }
}