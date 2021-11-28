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
  bool eventChannelActive = false;
  EventChannel? _stream;


  void handleTrackChanges(SpotifyApi spotify) {
    print("handleTrackChanges");
    this.spotifyApi = spotify;
    if(eventChannelActive== false){
      _stream = EventChannel('track_change');
      _stream!.receiveBroadcastStream().listen((event) {
        print("received broadcast in dart");
        addCurrentlyPlayingToDB(spotifyApi!, event);
      });
      eventChannelActive = true;
    }
  }


}
