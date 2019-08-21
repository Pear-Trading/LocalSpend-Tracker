import 'package:flutter/material.dart';
import 'package:flutter_maps/flutter_maps.dart';
import 'package:local_spend/common/felixApiCreds.dart';

class MapPage extends StatefulWidget {
  MapPage({Key key}) : super(key: key);

  @override
  _MapPageState createState() {
    return _MapPageState();
  }
}

class _MapPageState extends State<MapPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var fac = new FelixApiCreds();

    // TODO: implement build
    return Text(fac.mapsApiKey);
  }
}