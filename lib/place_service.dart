// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:google_maps_and_places/model/places_model.dart';
import 'package:http/http.dart';

class PlaceApiProvider {
  final client = Client();

  static const String androidKey = 'AIzaSyDtBoDqh6Vr0qg9q9iKLotrmq19d67rBj8';
  static const String iosKey = 'YOUR_API_KEY_HERE';
  final apiKey = Platform.isAndroid ? androidKey : iosKey;

  Future<List<Predictions>> fetchSuggestions(String input, String lang) async {
    final request =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&types=address&language=$lang&key=$apiKey';
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

  // Future<Places> getPlaceDetailFromId(String placeId) async {
  //   final request =
  //       'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=address_component&key=$apiKey';
  //   final response = await client.get(Uri.parse(request));

  //   if (response.statusCode == 200) {
  //     final result = json.decode(response.body);
  //     if (result['status'] == 'OK') {
  //       final components =
  //           result['result']['address_components'] as List<dynamic>;
  //       // build result
  //       final place = Place();
  //       for (var c in components) {
  //         final List type = c['types'];
  //         if (type.contains('street_number')) {
  //           place.streetNumber = c['long_name'];
  //         }
  //         if (type.contains('route')) {
  //           place.street = c['long_name'];
  //         }
  //         if (type.contains('locality')) {
  //           place.city = c['long_name'];
  //         }
  //         if (type.contains('postal_code')) {
  //           place.zipCode = c['long_name'];
  //         }
  //       }
  //       return place;
  //     }
  //     throw Exception(result['error_message']);
  //   } else {
  //     throw Exception('Failed to fetch suggestion');
  //   }
  // }
}
