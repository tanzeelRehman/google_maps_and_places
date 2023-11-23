import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sb_myreports/core/utils/globals/globals.dart';

abstract class PolyLineInfo {
  Future<List<LatLng>> getPolyLineCoordinates(
      LatLng sourceLocation, LatLng destinationLocation);

  List<LatLng> getPolyLineCoordinatesFromEncodedString(
      String encodedPolylineString);
}

class PolyLineInfoImp extends PolyLineInfo {
  PolylinePoints polylinePoints = PolylinePoints();
  @override
  Future<List<LatLng>> getPolyLineCoordinates(
      LatLng sourceLocation, LatLng destinationLocation) async {
    List<LatLng> polylineCoordinates = [];
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey, // Your Google Map Key
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(destinationLocation.latitude, destinationLocation.longitude),
    );
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        );
      }
    }
    return polylineCoordinates;
  }

  @override
  List<LatLng> getPolyLineCoordinatesFromEncodedString(
      String encodedPolylineString) {
    List<PointLatLng> result =
        polylinePoints.decodePolyline(encodedPolylineString);
    return result.map((e) => LatLng(e.latitude, e.longitude)).toList();
  }
}
