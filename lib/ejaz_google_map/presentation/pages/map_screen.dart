import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sb_myreports/core/utils/google_map/custom_map_markers.dart';
import 'package:sb_myreports/features/google_map/data/models/get_query_place_response_model.dart';
import 'package:sb_myreports/features/google_map/presentation/manager/map_provider.dart';
import 'package:sb_myreports/features/google_map/presentation/widgets/custom_search_delegate.dart';
// import 'package:sb_myreports/core/utils/constants/app_assets.dart';

import '../../../../core/utils/globals/globals.dart';

class GoogleMapScreen extends StatelessWidget {
  GoogleMapScreen({Key? key}) : super(key: key);
  MapProvider mapProvider = sl();
  // Provider state managements

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: mapProvider, child: const GoogleMapScreenContent());
  }
}

class GoogleMapScreenContent extends StatefulWidget {
  const GoogleMapScreenContent({Key? key}) : super(key: key);

  @override
  State<GoogleMapScreenContent> createState() => _GoogleMapScreenContentState();
}

class _GoogleMapScreenContentState extends State<GoogleMapScreenContent> {
  final Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController googleMapController;
  // camera position on scroll
  double previousZoom = 0;
  MapProvider mapProvider = sl();
  @override
  void initState() {
    super.initState();
    context.read<MapProvider>().getLocationOnce();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await MapMarkers.initialize();
      googleMapController = await _controller.future;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: floatingActionButton(),
        appBar: appbar(),
        body: SafeArea(
          child: Consumer<MapProvider>(builder: (context, provider, child) {
            if (provider.currentLocationLoading.value) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
            return Stack(
              children: [
                GoogleMap(
                  mapType: provider.mapUtils.getMapType(),
                  compassEnabled: true,
                  markers: {
                    ...provider.locationMarkers,
                    ...provider.labelMarkers
                  },
                  initialCameraPosition: CameraPosition(
                    target: provider.currentLocation!.value,
                    zoom: 13.5,
                  ),
                  circles: <Circle>{
                    Circle(
                        circleId: const CircleId("userLocation"),
                        center: provider.currentLocation!.value,
                        radius: 100,
                        strokeWidth: 1,
                        strokeColor: Colors.blue,
                        fillColor: Colors.blue.withOpacity(0.2))
                  },
                  polylines: {
                    if (provider.polylinePoints != null)
                      Polyline(
                        polylineId: const PolylineId("route"),
                        points: provider.polylinePoints!,
                        color: Colors.blue,
                        patterns: [
                          PatternItem.dot,
                          PatternItem.dash(30),
                          PatternItem.gap(10)
                        ],
                        width: 6,
                      ),
                  },
                  onCameraMove: (position) async {
                    mapProvider.mapUtils.currentCamPosition = position;
                  },
                  onCameraMoveStarted: () async {
                    // if (provider.polylinePoints != null&&provider.mapUtils.currentCamPosition!=) {
                    //   provider.removeAllMarkersExceptSourceDestination();
                    // }
                  },
                  onCameraIdle: () async {
                    /// only updates marker labels when zoom is not same and the
                    /// markers are not getting updated
                    if (provider.polylinePoints != null) {
                      double zoom = await googleMapController.getZoomLevel();
                      if (zoom != previousZoom) {
                        previousZoom = zoom;
                        provider.getLabels(zoom);
                      }
                    }
                  },
                  onMapCreated: (mapController) async {
                    previousZoom = await mapController.getZoomLevel();
                    _controller.complete(mapController);
                    provider.mapUtils.googleMapController = mapController;
                  },
                ),

                /// map current location
                Positioned(
                  right: 15,
                  top: 15,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(500),
                    child: GestureDetector(
                      onTap: () => provider.mapUtils.gotoCurrentLocation(),
                      child: const ColoredBox(
                        color: Colors.white,
                        child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Icon(Icons.my_location)),
                      ),
                    ),
                  ),
                ),

                /// map type
                Positioned(
                  right: 15,
                  top: 70,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(500),
                    child: GestureDetector(
                      onTap: () => setState(() {
                        if (provider.mapUtils.selectedMap < 2) {
                          provider.onMapTypeChange(
                              provider.mapUtils.selectedMap += 1);
                        } else {
                          provider.onMapTypeChange(0);
                        }
                      }),
                      child: const ColoredBox(
                        color: Colors.white,
                        child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Icon(Icons.map)),
                      ),
                    ),
                  ),
                ),

                /// tilt Camera
                Positioned(
                  right: 15,
                  top: 125,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(500),
                    child: GestureDetector(
                      onTap: () => provider.mapUtils.tiltCamera(),
                      child: const ColoredBox(
                        color: Colors.white,
                        child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Icon(Icons.camera)),
                      ),
                    ),
                  ),
                ),

                ValueListenableBuilder<bool>(
                  valueListenable: provider.polyLinesLoading,
                  builder: (context, value, child) {
                    if (value) {
                      return Center(
                        child: Container(
                            alignment: Alignment.center,
                            height: 50,
                            width: 50,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const CircularProgressIndicator.adaptive()),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  /// functions

  /// widgets
  Widget floatingActionButton() {
    return ValueListenableBuilder<LatLng?>(
      valueListenable: mapProvider.destinationLocation,
      builder: (context, value, child) => value == null
          ? const SizedBox()
          : FloatingActionButton.extended(
              label: Text(
                "Cancel",
                style: Theme.of(context).textTheme.bodyText1,
              ),
              onPressed: () async {
                mapProvider.cancelNavigation();
                await mapProvider.mapUtils.resetPostion();
              },
            ),
    );
  }

  PreferredSize appbar() {
    return PreferredSize(
      preferredSize: const Size(double.infinity, 50),
      child: ValueListenableBuilder<LatLng?>(
          valueListenable: mapProvider.destinationLocation,
          builder: (context, value, child) => value != null
              ? const SizedBox()
              : AppBar(
                  toolbarHeight: 50,
                  title: GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "Search Here",
                        style: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(color: Colors.black),
                      ),
                    ),
                    onTap: () async {
                      var result = await showSearch(
                        context: context,
                        delegate: CustomSearchDelegate(),
                      );
                      if (result is PlaceResult) {
                        mapProvider.drawPolyLinesForDestination(
                            result, googleMapController);
                      }
                    },
                  ))),
    );
  }
}
