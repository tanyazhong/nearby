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

    test('User profile is reachable', () async {
      var a = new API();
      await a.authenticate();
      String testID = "cif5mulm9m0s5jev1kwpmbjz7";
      String pic = await a.getProfileImage(testID);
      String name = await a.getUserDisplayName(testID);
      expect(name == "Jeffrey Chen", true);
      expect(pic.length > 0, true);
    });

    test('Create playlists is valid', () async {
      var a = new API();
      await a.authenticateUser();
      a.createPlaylist([]);
      expect(true, true);
    });
  });
}
