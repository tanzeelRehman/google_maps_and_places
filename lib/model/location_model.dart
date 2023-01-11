class LocationModel {
  LocationModel({
    required this.htmlAttributions,
    required this.result,
    required this.status,
  });
  late final List<dynamic> htmlAttributions;
  late final Result result;
  late final String status;

  LocationModel.fromJson(Map<String, dynamic> json) {
    htmlAttributions =
        List.castFrom<dynamic, dynamic>(json['html_attributions']);
    result = Result.fromJson(json['result']);
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['html_attributions'] = htmlAttributions;
    data['result'] = result.toJson();
    data['status'] = status;
    return data;
  }
}

class Result {
  Result({
    required this.addressComponents,
    required this.adrAddress,
    required this.formattedAddress,
    required this.geometry,
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconMaskBaseUri,
    required this.name,
    required this.placeId,
    required this.reference,
    required this.types,
    required this.url,
    required this.utcOffset,
    required this.vicinity,
  });
  late final List<AddressComponents> addressComponents;
  late final String adrAddress;
  late final String formattedAddress;
  late final Geometry geometry;
  late final String icon;
  late final String iconBackgroundColor;
  late final String iconMaskBaseUri;
  late final String name;
  late final String placeId;
  late final String reference;
  late final List<String> types;
  late final String url;
  late final int utcOffset;
  late final String vicinity;

  Result.fromJson(Map<String, dynamic> json) {
    addressComponents = List.from(json['address_components'])
        .map((e) => AddressComponents.fromJson(e))
        .toList();
    adrAddress = json['adr_address'];
    formattedAddress = json['formatted_address'];
    geometry = Geometry.fromJson(json['geometry']);
    icon = json['icon'];
    iconBackgroundColor = json['icon_background_color'];
    iconMaskBaseUri = json['icon_mask_base_uri'];
    name = json['name'];
    placeId = json['place_id'];
    reference = json['reference'];
    types = List.castFrom<dynamic, String>(json['types']);
    url = json['url'];
    utcOffset = json['utc_offset'];
    vicinity = json['vicinity'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['address_components'] =
        addressComponents.map((e) => e.toJson()).toList();
    data['adr_address'] = adrAddress;
    data['formatted_address'] = formattedAddress;
    data['geometry'] = geometry.toJson();
    data['icon'] = icon;
    data['icon_background_color'] = iconBackgroundColor;
    data['icon_mask_base_uri'] = iconMaskBaseUri;
    data['name'] = name;
    data['place_id'] = placeId;
    data['reference'] = reference;
    data['types'] = types;
    data['url'] = url;
    data['utc_offset'] = utcOffset;
    data['vicinity'] = vicinity;
    return data;
  }
}

class AddressComponents {
  AddressComponents({
    required this.longName,
    required this.shortName,
    required this.types,
  });
  late final String longName;
  late final String shortName;
  late final List<String> types;

  AddressComponents.fromJson(Map<String, dynamic> json) {
    longName = json['long_name'];
    shortName = json['short_name'];
    types = List.castFrom<dynamic, String>(json['types']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['long_name'] = longName;
    data['short_name'] = shortName;
    data['types'] = types;
    return data;
  }
}

class Geometry {
  Geometry({
    required this.location,
    required this.viewport,
  });
  late final Location location;
  late final Viewport viewport;

  Geometry.fromJson(Map<String, dynamic> json) {
    location = Location.fromJson(json['location']);
    viewport = Viewport.fromJson(json['viewport']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['location'] = location.toJson();
    data['viewport'] = viewport.toJson();
    return data;
  }
}

class Location {
  Location({
    required this.lat,
    required this.lng,
  });
  late final double lat;
  late final double lng;

  Location.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
}

class Viewport {
  Viewport({
    required this.northeast,
    required this.southwest,
  });
  late final Northeast northeast;
  late final Southwest southwest;

  Viewport.fromJson(Map<String, dynamic> json) {
    northeast = Northeast.fromJson(json['northeast']);
    southwest = Southwest.fromJson(json['southwest']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['northeast'] = northeast.toJson();
    data['southwest'] = southwest.toJson();
    return data;
  }
}

class Northeast {
  Northeast({
    required this.lat,
    required this.lng,
  });
  late final double lat;
  late final double lng;

  Northeast.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
}

class Southwest {
  Southwest({
    required this.lat,
    required this.lng,
  });
  late final double lat;
  late final double lng;

  Southwest.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
}
