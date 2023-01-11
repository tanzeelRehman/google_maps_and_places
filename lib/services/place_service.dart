// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:google_map_polyline_new/google_map_polyline_new.dart';
import 'package:google_maps_and_places/model/location_model.dart';
import 'package:google_maps_and_places/model/places_model.dart';
import 'package:google_maps_and_places/utils/app_urls.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';

class PlaceApiProviderService {
  final client = Client();

  GoogleMapPolyline googleMapPolyline =
      GoogleMapPolyline(apiKey: AppUrls.androidKey);

  final apiKey = Platform.isAndroid ? AppUrls.androidKey : AppUrls.iosKey;

  late final List<LatLng>? routeCordinates;

  Future<List<Predictions>> fetchSuggestions(String input, String lang) async {
    final request =
        '${AppUrls.baseURL}${AppUrls.getSuggestedPlaces}=$input&types=address&language=$lang&key=${AppUrls.androidKey}';
    final response = await client.get(Uri.parse(request));

    if (response.statusCode == 200) {
      final result = json.decode(response.body);

      var placesObj = Places.fromJson(result);

      if (placesObj.status == 'OK') {
        return placesObj.predictions;
      }

      if (placesObj.status == 'ZERO_RESULTS') {
        return [];
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  Future<Result> getPlaceDetailFromId(String placeId) async {
    //  https://maps.googleapis.com/maps/api/place/details/json?placeid=EmBMYWhvcmUtSXNsYW1hYmFkIE1vdG9yd2F5LCBTYWJ6YXphciBCbG9jayBFIFNhYnphemFyIEhvdXNpbmcgU2NoZW1lIFBoYXNlIDEgJiAyIExhaG9yZSwgUGFraXN0YW4iLiosChQKEgkxkj8L1mMgORG3H-YzNhKDxRIUChIJk9kzkOACGTkR8CG5gq-U-8w&key=AIzaSyDtBoDqh6Vr0qg9q9iKLotrmq19d67rBj8
    final request =
        'https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeId&key=AIzaSyDtBoDqh6Vr0qg9q9iKLotrmq19d67rBj8';
    final response = await client.get(Uri.parse(request));

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      var locationObj = LocationModel.fromJson(result);
      if (locationObj.status == 'OK') {
        print('result is okay');
        return locationObj.result;
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  Future<List<LatLng>?> getPolyLines(LatLng origin, LatLng destination) async {
    routeCordinates = await googleMapPolyline.getCoordinatesWithLocation(
        origin: origin, destination: destination, mode: RouteMode.driving);

    return routeCordinates;
  }
}
