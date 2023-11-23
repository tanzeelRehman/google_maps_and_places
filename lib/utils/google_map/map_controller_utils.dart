import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapControllerUtils {
  LatLng? currentLocation;
  GoogleMapController? googleMapController;
  CameraPosition? currentCamPosition;
  bool isCameraTilted = false;

  /// 0: for normal, 1: for satalite
  /// 2: for terain
  int _selectedMap = 0;
  int get selectedMap => _selectedMap;
  set selectedMap(int value) {
    _selectedMap = value;
  }

  GoogleMapControllerUtils(this.currentLocation,
      {this.currentCamPosition,
      this.googleMapController,
      this.isCameraTilted = false});

  /// Animates back to users current location
  gotoCurrentLocation() async {
    await googleMapController!.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: currentLocation!, zoom: 15)));
  }

  /// tilt and untilts the camera based on the variable
  /// [isCameraTilted] defined above
  Future<void> tiltCamera() async {
    CameraPosition newPosition = CameraPosition(
        target: currentCamPosition!.target,
        zoom: currentCamPosition!.zoom,
        bearing: currentCamPosition!.bearing,
        tilt: !isCameraTilted ? 90 : 0);
    await googleMapController!.animateCamera(
      CameraUpdate.newCameraPosition(newPosition),
    );
    isCameraTilted = !isCameraTilted;
  }

  resetPostion({bool tiltCamera = false}) async {
    if (isCameraTilted || tiltCamera) {
      CameraPosition newPosition = CameraPosition(
          target: currentLocation!,
          zoom: tiltCamera ? 18 : currentCamPosition?.zoom ?? 14,
          bearing: currentCamPosition?.bearing ?? 0,
          tilt: !isCameraTilted ? 90 : 0);
      await googleMapController!.animateCamera(
        CameraUpdate.newCameraPosition(newPosition),
      );
      isCameraTilted = !isCameraTilted;
    }
  }

  /// chanage map type from normal->satalite->terain->normal and so on
  MapType getMapType() {
    switch (selectedMap) {
      case 0:
        return MapType.normal;
      case 1:
        return MapType.satellite;
      case 2:
        return MapType.terrain;
      default:
        return MapType.normal;
    }
  }

  /// for rotating the camera with the mobile rotation
  Future<void> changeCameraRotation(double rotation) async {
    CameraPosition newPosition = CameraPosition(
      target: currentLocation!,
      zoom: currentCamPosition?.zoom ?? 13.5,
      bearing: rotation,
      tilt: isCameraTilted ? 90 : 0,
    );
    await googleMapController!.animateCamera(
      CameraUpdate.newCameraPosition(newPosition),
    );
  }
}
