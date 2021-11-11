import 'package:location/location.dart';

class locate {
  var _locationData;
  late PermissionStatus _permissionGranted;
  late bool _serviceEnabled;
  Location location = Location();
  Future checkLocationService() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
  }

  Future checkPermission() async {
    _permissionGranted = await location.hasPermission();
    //print("pls give permission");
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  Future<LocationData> findLocation() async {
    _locationData = await location.getLocation();
    return _locationData;
  }

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
