import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:local_spend/common/apifunctions/get_map_data.dart' as mapData;
import 'package:local_spend/common/platform/platform_scaffold.dart';

class MapPage extends StatefulWidget {
  MapPage({Key key}) : super(key: key);

  @override
  _MapPageState createState() {
    return _MapPageState();
  }
}

class _MapPageState extends State<MapPage> {
  final Map<String, gmaps.Marker> _markers = {};
  Future<void> _onMapCreated(gmaps.GoogleMapController controller) async {
    final region = await controller.getVisibleRegion();
    final locations = await mapData.getLocations(region.northeast, region.southwest);
    setState(() {
      _markers.clear();
      for (final location in locations.locations) {
        final marker = gmaps.Marker(
          markerId: gmaps.MarkerId(location.organisation.name),
          position: gmaps.LatLng(location.lat, location.lng),
          infoWindow: gmaps.InfoWindow(
            title: location.organisation.name,
            snippet: location.organisation.postcode,
          ),
        );
        _markers[location.organisation.name] = marker;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        title: Text(
          "Map",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: gmaps.GoogleMap(
        myLocationButtonEnabled: false,
        mapType: gmaps.MapType.hybrid,
        onMapCreated: _onMapCreated,
        initialCameraPosition: gmaps.CameraPosition(
          target: gmaps.LatLng(54.0411301, -2.8104042),
          zoom: 15,
        ),
      ),
    );
  }
}
