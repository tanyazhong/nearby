import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/main.dart';
import 'package:my_app/pages/grid_view_page.dart';
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
    track = value;
    print('track is ');
      });

  group('SongPage', ()
  {
    test('Song Page will return Widget from artistList()', () {
      expect(SongWidget(trackID: '4pvb0WLRcMtbPGmtejJJ6y?si=c123ba3cb2274b8f', userID: '1234')
          .createState()
          .artistList(Track()) is Widget, true);
    });
  });

  bool onChanged(FilterValues values){
    values.gridView = true;
    return values.gridView;
  }

  group('FilterPage', ()
  {
    test('OnChanged will send back updated values', () {
      FilterValues testing = FilterValues();
      testing.gridView = false;
      FilterPage(filterValues: testing, onChanged: onChanged).createState().onChanged(testing);
      expect(onChanged(testing), true);
    });
  });
}

