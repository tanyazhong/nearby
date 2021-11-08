import 'package:mongo_dart/mongo_dart.dart';
import 'dart:developer';
import 'package:flutter/foundation.dart';

class MongoDatabase {
  static var db, userCollection;

  static Map<dynamic, dynamic> generateMap(List<dynamic> lats, List<dynamic> lons,
      List<dynamic> songTitles, List<dynamic> artistNames,
      List<dynamic> spotifyUrls, List<dynamic> userIds) {
    var result = new Map();
    for (int i = 0; i < lats.length; i++) {
      // TODO: create new LatLon object out of LatLon?
      String latlon = lats[i].toString() + "," + lons[i].toString();
      result[latlon] = [songTitles[i], artistNames[i], spotifyUrls[i], userIds[i]];
    }
    return result;
  }

  static connect() async {
    log("connecting!");
    //String mongourl = "";mongodb+srv://root:<password>@cluster0.ghrni.mongodb.net/myFirstDatabase?retryWrites=true&w=majority
    final db = await Db.create("mongodb+srv://root:nEARby1234@cluster0.ghrni.mongodb.net/nearbySongs?retryWrites=true&w=majority");
    await db.open();
    log("here");
    userCollection = db.collection("nearbySongs");
    log("async");
    print(userCollection);
  }

  static Future<Map<dynamic, dynamic>> getDocuments() async {
    await connect();
    var results;
    log("getting docs");
    try {
      results = await userCollection.find().toList();
      debugPrint("hiiiii $results");
      List<dynamic> lats = results.map((m)=>m['lat']).toList();
      List<dynamic> lons= results.map((m)=>m['lon']).toList();
      List<dynamic> songTitles= results.map((m)=>m['songTitle']).toList();
      List<dynamic> artistNames= results.map((m)=>m['artistName']).toList();
      List<dynamic> spotifyUrls= results.map((m)=>m['spotifyUlr']).toList();
      List<dynamic> userIds= results.map((m)=>m['userId']).toList();

      debugPrint("lats: $lats");
      debugPrint("lons: $lons");

      var resultMap = generateMap(lats, lons, songTitles, artistNames, spotifyUrls, userIds);//new Map();

      debugPrint("both: $resultMap");
      return resultMap;
    } catch(e) {
      inspect(e);
      print(e);
    }
    //db.close();
    log("here");
    return results;
  }

  // String will be replaced with the Object of type we will be inserting
  // Like SongPlayInstance
  static insert(String name, int age) async {
    await userCollection.insertAll({"name":name, "age":age});
  }

  static update(ObjectId id, String name) async {
    var r = await userCollection.findOne({"_id":id});
    await userCollection.save({"name":name});
  }

  static delete(ObjectId info) async {
    await userCollection.remove(where.id(info));
  }
}