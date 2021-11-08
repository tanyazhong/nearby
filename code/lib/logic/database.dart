import 'package:mongo_dart/mongo_dart.dart';
import 'dart:developer';
import 'package:flutter/foundation.dart';

class MongoDatabase {
  static var db, userCollection;

  static connect() async {
    log("connecting!");
    String mongourl = "";
    final db = await Db.create(mongourl);
    await db.open();
    userCollection = db.collection("nearbyTest");
    log("async");
    print(userCollection);
  }

  static Future<Map<dynamic, dynamic>> getDocuments() async {
    await connect();
    var results;
    log("getting docs");
    try {
      results = await userCollection.find().toList();
      log("no errors!");
      //var type = results.runTimeType;
      debugPrint("hiiiii $results");
      List<dynamic> names = results.map((m)=>m['name']).toList();
      List<dynamic> ages= results.map((m)=>m['age']).toList();
      debugPrint("names: $names");
      debugPrint("ages: $ages");
      var twoDList = List.generate(10, (i) => List.filled(10, null, growable: false), growable: false);
      var resultMap = new Map();
      resultMap['coordinate1'] = [names[0], ages[0]];
      resultMap['coordinate2'] = [names[1], ages[1]];
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
  static insert(String info) async {
    await userCollection.insertAll({"name":info});
  }

  static update(ObjectId id, String name) async {
    var r = await userCollection.findOne({"_id":id});
    await userCollection.save({"name":name});
  }

  static delete(ObjectId info) async {
    await userCollection.remove(where.id(info));
  }
}