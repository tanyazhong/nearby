import 'package:location/location.dart';

class locate {
  var _locationData;
  late PermissionStatus _permissionGranted;
  late bool _serviceEnabled;
  Location location = Location();

  /// Checks if user has location service enabled
  ///
  /// This is an asynchronous function which returns a boolean future.
  /// It first checks if the user has enabled their location service on their device and if they haven't, it prompts the user to enable their location services.
  /// If the user doesn't want to enable location services, the function return false, but if the user does or has already enabled location services, it returns true.
  /// This provides a modular way for prompting the user to enable their location services. This is important because the app only works if these services are enabled
  Future<bool> checkLocationService() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return false;
      }
    }
    return true;
  }

  /// Checks if user has given our app permission to access their location
  ///
  /// This is an asynchronous function which returns a boolean future.
  /// It first checks if the user has given the app permission to access their location, and if they haven't, it prompts the user to enable their location services.
  /// If the user doesn't want to give the app their permission to access their location, the function return false, but if the user does or has already given permission, it returns true.
  /// This provides a modular way for prompting the user to give their permission for the app to access their location . This is important because our app only works if the app has their permission to access their location
  Future<bool> checkPermission() async {
    _permissionGranted = await location.hasPermission();
    //print("pls give permission");
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  /// Returns a user's location
  ///
  /// This is an asynchronous function which returns a LocationData future.
  /// It uses the location packages getLocation() function and returns its result.
  Future<LocationData> findLocation() async {
    _locationData = await location.getLocation();
    return _locationData;
  }

  /// Prints a user's location into the console
  ///
  /// This is used for testing purposes to make sure that a user's location is being fetched properly
  Future<void> printLocation() async {
    try {
      print('Awaiting user location...');
      var userLocation = await findLocation();
      print(userLocation);
    } catch (err) {
      print('Caught error: $err');
    }
  }
}
