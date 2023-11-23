// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:google_maps_flutter/google_maps_flutter.dart';

class GetDirectionRequestModel {
  final LatLng source;
  final LatLng destination;
  GetDirectionRequestModel({
    required this.source,
    required this.destination,
  });
}
