import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_maps_and_places/model/places_model.dart';
import 'package:google_maps_and_places/place_provider.dart';
import 'package:google_maps_and_places/place_service.dart';
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
  late GoogleMapController mapController;
  late PlaceApiProvider apiClient;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  TextEditingController addressController = TextEditingController();

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  final GlobalKey _key = GlobalKey();

  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    apiClient = PlaceApiProvider();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: scrollController,
        child: SafeArea(
            child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 11.0,
                ),
              ),
            ),
            Positioned(
              top: 20,
              left: 50,
              right: 50,
              child: searchWidget(context),
            ),
          ],
        )),
      ),
    );
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
          onSuggestionSelected: (suggestion) {
            // Navigator.of(context).push(MaterialPageRoute(
            //   builder: (context) => ProductPage(product: suggestion)
            // ));
          },
        ));
  }
}
