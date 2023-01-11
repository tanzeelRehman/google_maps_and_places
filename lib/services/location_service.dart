// ignore_for_file: avoid_print

import 'package:location/location.dart';

class LocationService {
  late Location _location;
  late LocationData _currentLocation;
  LocationService() {
    _location = Location();
  }

  Location get getLocationIns => _location;

  Future<dynamic> getLoc() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    print("Getting Device Location");
    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      print(
          "No location service is not enabled, requesting location permission");
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        print("No location permission granted");
        return "No location permission granted";
      }
    }

    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return "No location permission granted";
      }
    }

    return _currentLocation = await _location.getLocation();
  }
}
