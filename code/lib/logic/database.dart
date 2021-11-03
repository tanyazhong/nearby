import 'package:mongo_dart/mongo_dart.dart';
import 'dart:developer';
import 'package:flutter/foundation.dart';

class MongoDatabase {
  static var db, userCollection;

  static connect() async {
    log("connecting!");
    final db = await Db.create("mongodb+srv://root:nEARby1234@cluster0.ghrni.mongodb.net/nearby?retryWrites=true&w=majority");
    await db.open();
    userCollection = db.collection("nearbyTest");
    log("async");
    print(userCollection);
  }

  static Future<List<Map<String, dynamic>>> getDocuments() async {
    await connect();
    var results;
    log("getting docs");
    try {
      results = await userCollection.find().toList();
      log("no errors!");
      //var type = results.runTimeType;
      debugPrint("hiiiii $results");
      return results;

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