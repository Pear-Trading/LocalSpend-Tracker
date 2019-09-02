import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:local_spend/common/apifunctions/find_organisations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;

// /v1/supplier/location

@JsonSerializable()
class LatLng {
  LatLng({
    this.lat,
    this.lng
  });

  final double lat, lng;
}

@JsonSerializable()
class Region {
  Region({
    this.coords,
    this.id,
    this.name,
    this.zoom
  });

  final LatLng coords;
  final String id, name;
  final double zoom;
}

@JsonSerializable()
class Location {
  Location({
    this.organisation,
    this.lat,
    this.lng
  });

  final Organisation organisation;
  final double lat, lng;
}

@JsonSerializable()
class Locations {
  Locations({
    this.locations,
    this.regions
  });

  final List<Location> locations;
  final List<Region> regions;
}

Future<Locations> getLocations(gmaps.LatLng ne, gmaps.LatLng sw) async {
  const pearLocationsURL = 'https://dev.localspend.co.uk/api/v1/supplier/location';
  SharedPreferences preferences = await SharedPreferences.getInstance();

  Map<String, String> body;

  body = {
    'session_key': preferences.get('LastToken'),
  };

  Map<String, Map<String, double>> mapData = {
    'north_east': {
      'latitude':  ne.latitude,
      'longitude': ne.longitude
    },
    'south_west': {
      'latitude':  sw.latitude,
      'longitude': sw.longitude
    },
  };

  final response = await http.post(
    pearLocationsURL,
    body: json.encode(body),
  );

  if (response.statusCode == 200) {
    print(response.body.toString());
  } else {
    print(response.body.toString());
    throw HttpException(
      'Error - ' + response.reasonPhrase,
    );
  }
}