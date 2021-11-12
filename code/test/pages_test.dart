import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/pages/song.dart';
import 'package:my_app/pages/filter_page.dart';
import 'package:my_app/api.dart';
import 'package:spotify/spotify.dart';

void main() {
  SpotifyApi spotify = API().authenticate();
  Track? track;
  spotify.tracks
      .get('4pvb0WLRcMtbPGmtejJJ6y?si=c123ba3cb2274b8f')
      .then((value) {
    track = value;});

  group('SongPage', () {
    test('Song Page will retrieve artist list', () {
      Widget result = Song(track: track!).createState().artistList();
      expect(result != null, true);});
  });
}