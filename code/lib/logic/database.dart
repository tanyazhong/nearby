import 'package:mongo_dart/mongo_dart.dart';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'dart:math';
import 'package:collection/collection.dart';

/// An API that controls all MongoDB controls
class MongoDatabase {
  /// The variable to hold onto the MongoDB instance
  static var db;

  /// The collection of song data retreived from the database
  static var songCollection;

  /// Converts the input degrees to radians and returns the result
  static double degreesToRadians(double degree) {
    return (degree * pi / 180);
  }

  /// Returns `true` if the provided latitude and longitude pair are within distance of the other provided lat and lon pair
  static bool withinDistance(
      double lat1, double lon1, double lat2, double lon2, double distance) {
    /// The radius of Earth
    final R = 6371;

    double d =
        acos(sin(lat1) * sin(lat2) + cos(lat1) * cos(lat2) * cos(lon1 - lon2)) *
            R;
    if (d < distance) {
      return true;
    }
    return false;
  }

  /// Returns a list of songIds that are within distance of the provided lat and lon pair
  static Future<List<dynamic>> getNearbySongsForLoc(
      double lat, double lon, double distance) async {
    List<dynamic> results = [];

    /// The documents currently held in the database
    Map<dynamic, dynamic> documents = await MongoDatabase.getDocuments();

    Iterable<dynamic> coordinates = documents.keys;
    for (var coord in coordinates) {
      dynamic cur = coord.split(",");
      double curLat = degreesToRadians(double.parse(cur[0]));
      double curLon = degreesToRadians(double.parse(cur[1]));
      if (withinDistance(degreesToRadians(lat), degreesToRadians(lon), curLat,
          curLon, distance)) {
        results.add(documents[coord]);
      }
    }
    debugPrint("result in getNearbySongs: $results");
    return results;
  }

  /// Connects to the Mongo DataBase
  static connect() async {
    debugPrint("connecting!");
    //String mongourl = "";mongodb+srv://root:<password>@cluster0.ghrni.mongodb.net/myFirstDatabase?retryWrites=true&w=majority
    final db = await Db.create(
        "mongodb+srv://root:nEARby1234@cluster0.ghrni.mongodb.net/nearbySongs?retryWrites=true&w=majority");
    await db.open();
    debugPrint("here");
    songCollection = db.collection("nearbySongs");
    debugPrint("async");
  }

  // Returns the documents in the Mongo Database
  static Future<Map<dynamic, dynamic>> getDocuments() async {
    await connect();
    var results;
    debugPrint("getting docs");
    try {
      results = await songCollection.find().toList();
      debugPrint("hiiiii $results");
      List<dynamic> lats = results.map((m) => m['lat']).toList();
      List<dynamic> lons = results.map((m) => m['lon']).toList();
      List<dynamic> songIds = results.map((m) => m['songId']).toList();
      List<dynamic> userIds = results.map((m) => m['userId']).toList();

      debugPrint("lats: $lats");
      debugPrint("lons: $lons");

      var resultMap = Map();
      for (int i = 0; i < lats.length; i++) {
        // TODO: create new LatLon object out of LatLon?
        String latlon = lats[i].toString() + "," + lons[i].toString();
        resultMap[latlon] = [songIds[i], userIds[i]];
      }

      debugPrint("both: $resultMap");
      return resultMap;
    } catch (e) {
      inspect(e);
    }
    //db.close();
    return results;
  }

  /// Inserts song data into the database for a location
  static insert(double lat, double lon, String songId, String userId) async {
    await songCollection.insertOne(
        {"lat": lat, "lon": lon, "songId": songId, "userId": userId});
  }
}
