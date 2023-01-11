import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_and_places/model/location_model.dart';
import 'package:google_maps_and_places/model/places_model.dart';
import 'package:google_maps_and_places/services/location_service.dart';
import 'package:google_maps_and_places/services/place_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:location/location.dart';

class PlaceProvider extends ChangeNotifier {
  late final Completer<GoogleMapController> googleMapCompleter;

  //* Properties.................................................................

  // External Services
  late LocationService locationService;
  late PlaceApiProviderService apiClient;

  // Objects
  late final loc.LocationData currentLocationData;
  late Result placeDetails;
  late List<Predictions> predlist;
  late loc.Location currentLocation;

  // Google Map Properties
  late GoogleMapController googleMapController;
  late List<LatLng> routeCordinates;
  final Set<Polyline> polyline = {};
  late final Set<Marker> mapMarkers = {};

  /// [Default] camera position for google maps
  LatLng initialcameraPosition =
      const LatLng(37.42796133580664, -122.085749655962);

  PlaceProvider() {
    apiClient = PlaceApiProviderService();
    locationService = LocationService();
    googleMapCompleter = Completer<GoogleMapController>();
  }

  //* Funcations ...............................................................................

  //! Call this function must in Google Maps screen [init] state
  Future<void> initilizeCompleter() async {
    googleMapController = await googleMapCompleter.future;
  }

  /// It will listen to [location Changes], Call this function must in Google Map [On Map created]
  void onMapCreated(GoogleMapController googleMapController) {
    locationService.getLocationIns.onLocationChanged.listen((l) {
      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude!, l.longitude!), zoom: 15),
        ),
      );
    });
  }

  /// Get list of [Search places] suggestions
  Future<List<Predictions>> getPredictions(String pattern) async {
    predlist = await apiClient.fetchSuggestions(pattern, 'en');

    return predlist;
  }

  /// Get detail of [Selected] place, From list of suggestions
  Future<void> getPlaceDetails(String placeId) async {
    placeDetails = await apiClient.getPlaceDetailFromId(placeId);
    print('getting place details');

    //Calculating Latlang for origin
    LatLng origin =
        LatLng(currentLocationData.latitude!, currentLocationData.longitude!);
    //Calculating Latlang for destination
    LatLng destination = LatLng(
        placeDetails.geometry.location.lat, placeDetails.geometry.location.lng);
    getPolyLines(origin, destination, placeId);
    notifyListeners();
  }

  /// Move Camera to a [specific location]
  //? Input => latitute
  Future<void> goToPlace(LatLng position) async {
    googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: position, zoom: 12)));
  }

  /// Draw polyline between [Origin & Destination]
  //? Input => LatLng of origin and Destination place
  Future<void> getPolyLines(
      LatLng origin, LatLng destination, String placeId) async {
    routeCordinates = (await apiClient.getPolyLines(origin, destination))!;

    polyline.add(Polyline(
      polylineId: PolylineId(placeId),
      visible: true,
      points: routeCordinates,
      width: 4,
      color: Colors.blue,
      startCap: Cap.roundCap,
      endCap: Cap.buttCap,
    ));
    print("POLYLINE IS");
    print(polyline.first.mapsId);

    notifyListeners();
  }

  /// Add markers on given [Position]
  //? Input => Latlang of that position
  Future<void> setMarkerOnMap(String markerId, LatLng position) async {
    mapMarkers.add(Marker(
        icon: BitmapDescriptor.defaultMarker,
        markerId: MarkerId(markerId),
        position: position));
    notifyListeners();
  }

  /// Get location of [Device]
  //? Must Call in the start
  Future<void> getLocationOnce() async {
    currentLocationData = await locationService.getLoc();

    locationService.getLocationIns.onLocationChanged
        .listen((LocationData currentLocation) {
      initialcameraPosition =
          LatLng(currentLocation.latitude!, currentLocation.longitude!);

      setMarkerOnMap(
          currentLocationData.time.toString(),
          LatLng(
              currentLocationData.latitude!, currentLocationData.longitude!));
    });
  }
}
