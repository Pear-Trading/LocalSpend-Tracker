import 'package:flutter/material.dart';
import 'package:local_spend/common/platform/platform_scaffold.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_spend/common/functions/logout.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:local_spend/common/functions/customAbout.dart' as custom;
import 'package:local_spend/common/functions/showDialogTwoButtons.dart';
import 'package:local_spend/common/widgets/charts/donut_chart.dart';
import 'package:local_spend/common/widgets/charts/outside_label.dart';
import 'package:local_spend/common/widgets/charts/auto_label.dart';
import 'package:local_spend/common/widgets/charts/grouped_bar_chart.dart';
import 'package:local_spend/common/widgets/charts/scatter_bucketingAxis_legend.dart';
import 'package:local_spend/common/widgets/charts/numeric_line_bar_combo.dart';
import 'package:local_spend/common/widgets/charts/series_legend_with_measures.dart';
import 'package:local_spend/common/widgets/charts/time_series_simple.dart';
import 'package:local_spend/common/apifunctions/get_graph_data.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:local_spend/common/widgets/charts/chart_builder.dart';

const URL = "https://flutter.io/";
const demonstration = false;

class StatsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new StatsPageState();
  }
}

class StatsPageState extends State<StatsPage> {

  GraphData graphData = new GraphData();
  List<charts.Series<dynamic, DateTime>> displayedGraphData;

  @override
  void initState() {
    super.initState();
    _saveCurrentRoute("/StatsPageState");
  }

  @override
  void dispose() {
    super.dispose();
  }

  _saveCurrentRoute(String lastRoute) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('LastPageRoute', lastRoute);
  }

  @override
  Widget build(BuildContext context) {
    if (graphData.data.length == 0) {
      graphData.getGraphData('total_last_week').then((fetchedData) {
        displayedGraphData = (fetchedData);
        for (int i = 0; i < fetchedData[0].data.length; i++) {
          print(fetchedData[0].data[i].time); // this is getting very frustrating
        }
        setState(() {});
      });
    }

    return PlatformScaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        title: Text(
          "Statistics",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
//          leading: BackButton(),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),


      body : Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: ListView(
          children: <Widget>[

            Container(
              padding: EdgeInsets.fromLTRB(0.0,17,0.0,0.0),
              child : Text(
                "This Week's Spend",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              height: 200,
//              width: 250,

//                child: new TimeSeries(),
              child: displayedGraphData != null ? new charts.TimeSeriesChart(displayedGraphData) : Container(), //List<Series<dynamic, DateTime>>
//              child: new charts.TimeSeriesChart(displayedGraphData),
//                child: new SimpleTimeSeriesChart(),//seriesList: List<charts.Series>
            ),

          ],
        ),
      ),
    );
  }
}
