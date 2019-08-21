import 'package:flutter/material.dart';
import 'package:local_spend/common/apifunctions/get_graph_data.dart';
//import 'package:charts_flutter/flutter.dart' as charts;

class OrgGraphs extends StatefulWidget {
  OrgGraphs({Key key}) : super(key: key);

  @override
  _OrgGraphsState createState() {
    return _OrgGraphsState();
  }
}

class _OrgGraphsState extends State<OrgGraphs> {
  GraphData totalLastWeekGraph = new GraphData("total_last_week");

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
    return ListView(
      children: <Widget>[],
    );
  }
}
