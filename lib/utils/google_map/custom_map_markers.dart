import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// provide access to custom map markers
class MapMarkers {
  static late BitmapDescriptor userLocationIcon;

  /// initialize all icons that are made from assets
  static Future<void> initialize() async {
    userLocationIcon = await getUserLocationIcon();
  }

  static Future<BitmapDescriptor> getUserLocationIcon() async {
    var icon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, "assets/images/user_location.png");
    return icon;
  }
}
