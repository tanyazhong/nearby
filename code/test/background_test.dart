
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/background.dart';
import 'package:spotify/spotify.dart';
import 'package:my_app/api.dart';
import 'package:integration_test/integration_test.dart';
import 'package:my_app/main.dart' as app;

void main()  {
  TrackChange trackChange = TrackChange();
  group('Background', () {
    test('Setup event channel', () async{
     app.main();

      SpotifyApi spotify = await API().authenticateUser();
      trackChange.handleTrackChanges(spotify);
      assert(trackChange.eventChannelActive, true);
    });
  });

}