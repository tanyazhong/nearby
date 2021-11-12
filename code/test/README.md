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

### api_test.dart
    flutter test test/api_test.dart
Scenario 3: Users are able to authenticate with Spotify 
- This unit test returns true if the returned SpotifyApi object is not null. 
- On failure, the test will throw an error and print "Unable to authenticate login with Spotify"
- Flutter makes it clear how many tests are passed after running the flutter test command.  

Scenario 4: Recently played songs returns a nonnull list of songs. 
- This unit test returns true if the recentlyPlayed function returns a valid iterable (Flutter's list data structure)
- On failure, the test will thrown an error and print "Recently played songs should be nonnull"

Scenario 5: Ensure that the Song Page can retrieve a Widget from artistList.
- This unit test will return true if a Widget is returned from calling artistList inside the class Song which renders the Song Page
- If this fails it means that an error occurred in creating the class _SongState or an instance of Track because artistList always returns a Widget
- This unit test is important because the Song Page needs to be dependable and not throw an error when requested.

Scenario 6: Ensure that the Filter Page can send values back to its parent widget through the callback onChanged
- This unit test will return true if a value in FilterValue is changed when it is called through the FilterPage class
- If the test fails it means that the callback function isn’t being accessed properly by the filter page
- This unit test is important because the Filter Page’s job is to allow the user to change settings that affect what they see on the grid view page.  The onChanged function sends the updated values back to GridViewPage

