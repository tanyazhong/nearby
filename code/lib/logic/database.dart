import 'package:mongo_dart/mongo_dart.dart';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'dart:math';

class MongoDatabase {
  static var db, userCollection;

  static double degreesToRadians(double degree) {
    return (degree * pi / 180);
  }

  static bool withinDistance(
      double lat1, double lon1, double lat2, double lon2, double distance) {
    // dist = arccos(sin(lat1) · sin(lat2) + cos(lat1) · cos(lat2) · cos(lon1 - lon2)) · R
    final R = 6371; // Earth has radius 6371KM
    double d =
        acos(sin(lat1) * sin(lat2) + cos(lat1) * cos(lat2) * cos(lon1 - lon2)) *
            R;
    if (d < distance) {
      return true;
    }
    return false;
  }

  static Future<List<dynamic>> getNearbySongsForLoc(
      double lat, double lon, double distance) async {
    List<dynamic> results = [];
    Map<dynamic, dynamic> documents = await MongoDatabase.getDocuments();
    debugPrint("hi doc $documents");

    Iterable<dynamic> coordinates = documents.keys;
    for (var coord in coordinates) {
      dynamic cur = coord.split(",");
      double curLat = degreesToRadians(double.parse(cur[0]));
      double curLon = degreesToRadians(double.parse(cur[1]));
      if (withinDistance(degreesToRadians(lat), degreesToRadians(lon), curLat,
          curLon, distance)) {
        results.add(coord);
      }
    }
    return results;
  }

  static Map<dynamic, dynamic> generateMap(List<dynamic> lats,
      List<dynamic> lons, List<dynamic> songIds, List<dynamic> userIds) {
    var result = new Map();
    for (int i = 0; i < lats.length; i++) {
      // TODO: create new LatLon object out of LatLon?
      String latlon = lats[i].toString() + "," + lons[i].toString();
      result[latlon] = [songIds[i], userIds[i]];
    }
    return result;
  }

  static connect() async {
    debugPrint("connecting!");
    //String mongourl = "";mongodb+srv://root:<password>@cluster0.ghrni.mongodb.net/myFirstDatabase?retryWrites=true&w=majority
    final db = await Db.create(
        "mongodb+srv://root:nEARby1234@cluster0.ghrni.mongodb.net/nearbySongs?retryWrites=true&w=majority");
    await db.open();
    debugPrint("here");
    userCollection = db.collection("nearbySongs");
    debugPrint("async");
    //debugPrint(userCollection);
  }

  static Future<Map<dynamic, dynamic>> getDocuments() async {
    await connect();
    var results;
    debugPrint("getting docs");
    try {
      results = await userCollection.find().toList();
      debugPrint("hiiiii $results");
      List<dynamic> lats = results.map((m) => m['lat']).toList();
      List<dynamic> lons = results.map((m) => m['lon']).toList();
      List<dynamic> songIds = results.map((m) => m['songId']).toList();
      List<dynamic> userIds = results.map((m) => m['userId']).toList();

      debugPrint("lats: $lats");
      debugPrint("lons: $lons");

      var resultMap = generateMap(
        lats,
        lons,
        songIds,
        userIds,
      ); //new Map();

      debugPrint("both: $resultMap");
      return resultMap;
    } catch (e) {
      inspect(e);
      //print(e);
    }
    //db.close();
    //log("here");
    return results;
  }

  // String will be replaced with the Object of type we will be inserting
  // Like SongPlayInstance
  static insert(String name, int age) async {
    await userCollection.insertAll({"name": name, "age": age});
  }

  static update(ObjectId id, String name) async {
    var r = await userCollection.findOne({"_id": id});
    await userCollection.save({"name": name});
  }

  static delete(ObjectId info) async {
    await userCollection.remove(where.id(info));
  }
}
