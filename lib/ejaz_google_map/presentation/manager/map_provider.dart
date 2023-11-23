import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:label_marker/label_marker.dart';
import 'package:location/location.dart';
import 'package:sb_myreports/core/utils/google_map/custom_map_markers.dart';
import 'package:sb_myreports/core/utils/google_map/polyLines.dart';
import 'package:sb_myreports/core/utils/location/location.dart';
import 'package:sb_myreports/features/google_map/data/models/get_direction_request_model.dart';
import 'package:sb_myreports/features/google_map/data/models/get_direction_response_model.dart';
import 'package:sb_myreports/features/google_map/data/models/get_query_place_request_model.dart';
import 'package:sb_myreports/features/google_map/data/models/get_query_place_response_model.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/utils/globals/snack_bar.dart';
import '../../../../core/utils/google_map/map_controller_utils.dart';
import '../../domain/use_cases/get_direction_use_case.dart';
import '../../domain/use_cases/get_query_place.dart';

class MapProvider extends ChangeNotifier {
  MapProvider(this._getQueryPlaceUsecase, this._getDirectionUsecase);

  /// variables
  late GoogleMapControllerUtils mapUtils;
  GetDirectionResponseModel? directionModel;
  bool isGettinLabels = false;
  bool isSettingRotaion = false;
  // double compassRotation = 0;
  List<LatLng>? polylinePoints;
  List<PlaceResult> locationsSearched = [];

  /// for example of the user and the destination point
  Set<Marker> locationMarkers = {};

  /// contains info about the road he is going to follow
  Set<Marker> labelMarkers = {};

  /// Utils
  final LocationImp _locationImp = LocationImp();
  final PolyLineInfoImp _polyLinesImp = PolyLineInfoImp();

  /// UserCases
  final GetQueryPlaceUsecase _getQueryPlaceUsecase;
  final GetDirectionUsecase _getDirectionUsecase;

  /// Streams Subscription
  StreamSubscription<LocationData>? locationStream;
  StreamSubscription<CompassEvent>? mobileCompassStream;

  //valuenotifiers
  ValueNotifier<LatLng>? currentLocation;
  ValueNotifier<LatLng?> destinationLocation = ValueNotifier(null);

  /// loaders
  ValueNotifier<bool> currentLocationLoading = ValueNotifier(false);
  ValueNotifier<bool> placeLoading = ValueNotifier(false);
  ValueNotifier<bool> polyLinesLoading = ValueNotifier(false);

  /// methods

  Future<void> getLocationOnce() async {
    currentLocationLoading.value = true;
    LocationData data = await _locationImp.getLocation();
    if (currentLocation == null) {
      currentLocation = ValueNotifier(LatLng(data.latitude!, data.longitude!));
      mapUtils = GoogleMapControllerUtils(currentLocation!.value);
      locationMarkers.add(
        Marker(
          markerId: const MarkerId("currentLocation"),
          position: currentLocation!.value,
          icon: MapMarkers.userLocationIcon,
        ),
      );
    } else {
      currentLocation!.value = LatLng(data.latitude!, data.longitude!);
    }
    currentLocationLoading.value = false;
    notifyListeners();
  }

  /// will keep on listening to location stream unless
  /// destination is reached or user cancels the ride
  Future<void> getLocationStream() async {
    polylinePoints = [];
    locationStream = _locationImp.getLocationStream().listen((data) {
      currentLocation!.value = LatLng(data.latitude!, data.longitude!);
    });
  }

  //usecases calls
  Future<void> getQueryPlace(String query) async {
    locationsSearched = [];
    placeLoading.value = true;
    final params = GetQueryPlaceRequestModel(query: query);
    var loginEither = await _getQueryPlaceUsecase(params);
    if (loginEither.isLeft()) {
      handleError(loginEither);
      placeLoading.value = false;
    } else if (loginEither.isRight()) {
      loginEither.foldRight(null, (response, previous) async {
        if (response.status == "OK") {
          {
            if (response.results!.isNotEmpty) {
              for (var i = 0; i < response.results!.length; i++) {
                locationsSearched.add(response.results![i]);
              }
            }
            placeLoading.value = false;
          }
        }
      });
    }
  }

  Future<void> getDirection() async {
    locationsSearched = [];
    placeLoading.value = true;
    final params = GetDirectionRequestModel(
        source: currentLocation!.value,
        destination: destinationLocation.value!);
    var loginEither = await _getDirectionUsecase(params);
    if (loginEither.isLeft()) {
      handleError(loginEither);
    } else if (loginEither.isRight()) {
      loginEither.foldRight(null, (response, previous) async {
        directionModel = response;
      });
    }
  }

  /// gets all the points from source to destination location
  /// and draws polyline on map
  void drawPolyLinesForDestination(
      PlaceResult destination, GoogleMapController mapCont) async {
    polyLinesLoading.value = true;
    var locate = destination.geometry!.location!;
    destinationLocation.value = LatLng(locate.lat!, locate.lng!);
    await getDirection();
    locationMarkers.add(Marker(
      markerId: const MarkerId("destination"),
      position: destinationLocation.value!,
    ));
    // polylinePoints = await _polyLinesImp.getPolyLineCoordinates(
    //     currentLocation!.value, destinationLocation.value!);
    polylinePoints = _polyLinesImp.getPolyLineCoordinatesFromEncodedString(
        directionModel!.routes!.first.overviewPolyline!.points!);
    await getLabels(await mapCont.getZoomLevel());
    addRotationListner();
    await mapUtils.resetPostion(tiltCamera: !mapUtils.isCameraTilted);
    polyLinesLoading.value = false;
    notifyListeners();
  }

  ///
  Future<void> getLabels(double zoomValue) async {
    if (!isGettinLabels) {
      removeAllMarkersExceptSourceDestination(shouldNotify: false);
      isGettinLabels = true;
      // print((25 - (zoomValue).toInt()));
      for (var i = 0; i < polylinePoints!.length; i++) {
        /// modify formula
        if (i % (30 - (zoomValue).toInt()) == 0 && i != 0) {
          await labelMarkers.addLabelMarker(
            LabelMarker(
              label: "TextToShow",
              markerId: MarkerId(i.toString()),
              position: polylinePoints![i],
              backgroundColor: Colors.blue,
            ),
          );
        }
      }
      // print(mapMarkers.length);
      isGettinLabels = false;
      notifyListeners();
    }
  }

  /// starts listening to mobile rotation changes
  void addRotationListner() {
    mobileCompassStream = FlutterCompass.events!.listen((event) async {
      if (!isSettingRotaion) {
        isSettingRotaion = true;
        await Future.delayed(const Duration(milliseconds: 2000));
        mapUtils.changeCameraRotation(event.heading ?? 0);
        isSettingRotaion = false;
      }
    });
  }

  ///
  void removeAllMarkersExceptSourceDestination({bool shouldNotify = true}) {
    labelMarkers.clear();
    if (shouldNotify) {
      notifyListeners();
    }
  }

  void onMapTypeChange(int value) {
    mapUtils.selectedMap = value;
    notifyListeners();
  }

  /// resets destinationLocation and
  /// polylines
  void cancelNavigation() {
    if (mobileCompassStream != null) {
      mobileCompassStream!.cancel();
    }
    labelMarkers.clear();
    locationMarkers = {locationMarkers.first};
    destinationLocation.value = null;
    polylinePoints = null;
    notifyListeners();
  }

  // Error Handling
  void handleError(Either<Failure, dynamic> either) {
    either.fold((l) => ShowSnackBar.show(l.message), (r) => null);
  }

  @override
  void dispose() {
    if (locationStream != null) {
      locationStream!.cancel();
    }
    if (mobileCompassStream != null) {
      mobileCompassStream!.cancel();
    }
    super.dispose();
  }
}
