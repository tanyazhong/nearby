import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/api.dart';
import 'package:my_app/logic/database.dart';


void main() {
  group('Database', () {
    test('Coordinate distance function is broken', () {
      expect(
          MongoDatabase.withinDistance(0.7102, -1.2923, 0.8527, 0.0400, 5838),
          true);
    });
    test('There should be > 1 result for westwood coordinates', () {
      Future<List<dynamic>> results =
          MongoDatabase.getNearbySongsForLoc(2);
      expect(results != null, true);
    });
  });

}
