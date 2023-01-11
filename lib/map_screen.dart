import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_maps_and_places/model/places_model.dart';

import 'package:google_maps_and_places/provider/place_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: ((context) => PlaceProvider()),
      child: MapScreenContent(),
    );
  }
}

class MapScreenContent extends StatefulWidget {
  @override
  State<MapScreenContent> createState() => _MapScreenContentState();
}

class _MapScreenContentState extends State<MapScreenContent> {
  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      context.read<PlaceProvider>().initilizeCompleter();
      context.read<PlaceProvider>().getLocationOnce();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Stack(
      children: [
        Consumer<PlaceProvider>(builder: ((context, value, child) {
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            child: GoogleMap(
              mapType: MapType.hybrid,
              polylines: context.read<PlaceProvider>().polyline,
              markers: context.read<PlaceProvider>().mapMarkers,
              initialCameraPosition: CameraPosition(
                  target: context.read<PlaceProvider>().initialcameraPosition,
                  zoom: 12),
              onMapCreated: (GoogleMapController controller) {
                context.read<PlaceProvider>().onMapCreated(controller);
              },
            ),
          );
        })),
        Positioned(
          top: 20,
          left: 50,
          right: 50,
          child: searchWidget(context),
        ),
      ],
    )));
  }

  Widget searchWidget(BuildContext context) {
    return Card(
        elevation: 10,
        child: TypeAheadField(
          minCharsForSuggestions: 2,
          hideOnEmpty: true,
          hideSuggestionsOnKeyboardHide: true,
          errorBuilder: (context, error) {
            return ListTile(
              title: Text(error.toString()),
            );
          },
          textFieldConfiguration: const TextFieldConfiguration(
            decoration: InputDecoration(
              suffixIcon: Icon(
                Icons.search,
                color: Color(0xFF1CB5B5),
              ),
              contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 0),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFF989393),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blue,
                ),
              ),
            ),
          ),
          noItemsFoundBuilder: (value) {
            var localizedMessage = "No items found!";
            return Text(localizedMessage);
          },
          suggestionsCallback: (pattern) async {
            return await context.read<PlaceProvider>().getPredictions(pattern);
          },
          itemBuilder: (context, suggestion) {
            if (suggestion is Predictions) {
              return ListTile(
                title: Text(suggestion.description),
              );
            }

            return const ListTile(
              title: Text("No Data"),
            );
          },
          onSuggestionSelected: (suggestion) async {
            //* Getting place details from place id
            await context
                .read<PlaceProvider>()
                .getPlaceDetails(suggestion.placeId);

            // goToPlace(LatLng(placePosoition.lat, placePosoition.lng));
          },
        ));
  }
}
