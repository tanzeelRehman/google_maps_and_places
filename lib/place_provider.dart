import 'package:flutter/material.dart';
import 'package:google_maps_and_places/model/places_model.dart';
import 'package:google_maps_and_places/place_service.dart';

class PlaceProvider extends ChangeNotifier {
  late List<Predictions> predlist;
  late PlaceApiProvider apiClient;

  PlaceProvider() {
    apiClient = PlaceApiProvider();
  }

  Future<List<Predictions>> getPredictions(String pattern) async {
    predlist = await apiClient.fetchSuggestions(pattern, 'en');

    return predlist;
  }
}
