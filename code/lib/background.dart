import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:spotify/spotify.dart';
import 'locate.dart';
import 'logic/database.dart';
import 'logic/database_entry.dart';

Future<void> addSongToDB(String? userID, String trackID) async {
  print("running add s, trackid is $trackID");
  LocationData location = await locate().findLocation();
  //Player currentlyPlaying = await spotify.me.currentlyPlaying();
  if (MongoDatabase.songCollection == null) {
    await MongoDatabase.connect();
    print('had to connect to db');
  }
  DatabaseEntry entry = DatabaseEntry();
  entry.userId = userID;
  entry.songId = trackID;
  entry.lon = location.longitude.toString();
  entry.lat = location.latitude.toString();
  print('lat is ${entry.lat}, lon is ${entry.lon}');
  print(entry);
  await MongoDatabase.insert(entry);
}

///callback top level function that adds currently playing song with current location to database
void addCurrentlyPlayingToDB(SpotifyApi spotify, String trackID) async {
  print("running callback, trackid is $trackID");
  LocationData location = await locate().findLocation();
  //Player currentlyPlaying = await spotify.me.currentlyPlaying();
  User user = await spotify.me.get();
  if (MongoDatabase.songCollection == null) {
    await MongoDatabase.connect();
    print('had to connect to db');
  }
  DatabaseEntry entry = DatabaseEntry();
  entry.userId = user.id;
  entry.songId = trackID;
  entry.lon = location.longitude.toString();
  entry.lat = location.latitude.toString();
  print('lat is ${entry.lat}, lon is ${entry.lon}');
  print(entry);
  await MongoDatabase.insert(entry);
}

class TrackChange extends ChangeNotifier {
  String? trackID;
  SpotifyApi? spotifyApi;

  @override
  TrackChange(SpotifyApi spotifyApi) {
    print("track change constructor");
    this.spotifyApi = spotifyApi;
    //  _handleTrackChanges();
    _createMethodChannel();
    _handleTrackChanges();
  }

  void _handleTrackChanges() {
    print("handleTrackChanges");
    const EventChannel _stream = EventChannel('track_change');
    _stream.receiveBroadcastStream().listen((event) {
      print("received broadcast in dart");
      addCurrentlyPlayingToDB(spotifyApi!, event);
    });
  }

  void _createMethodChannel() async {
    const MethodChannel _method = MethodChannel('method');
    try {
      int result = await _method.invokeMethod('try');
    } on PlatformException catch (e) {
      print("method got caught in error");
    }
  }
}
