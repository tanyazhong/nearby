import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/api.dart';
import 'package:spotify/spotify.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  group('API', () {
    test('Unable to authenticate login with Spotify', () async {
      var a = new API();
      var spotify = await a.authenticate();
      expect(spotify != null, true);
    });
    test('Recently played songs s', () async {
      var a = new API();
      await a.authenticate();
      var songs = a.getRecentlyPlayed(10);
      expect(songs != null, true);
    });
  });
}
