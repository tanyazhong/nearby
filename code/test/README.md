# Testing Folder

## How to run tests
    flutter test test/[testfile.dart]

## Included tests
### database_test.dart
    flutter test test/database_test.dart
Scenario 1: Validate coordinates are within distance d with CoordinateDistance
- a unit test that checks if the MongoDatabase.withinDistance function correctly returns true for 2 points 5837.5KM from each other with distance=5838.
- on failure, the test case will throw and error and print the statement “Coordinate distance function is broken.”

Scenario 2: Validate that the database contains data for coordinates within Westwood
- a unit test that ensures that the output from getNearBySongsForLoc(...) is non-empty when given coordinates within Westwood and a radius of 2KM because the database has a permanent entry with coordinates in Westwood
- on success, the unit test will return true
- on failure, the test will throw an error and “There should be >1 result for westwood coordinates” will print
