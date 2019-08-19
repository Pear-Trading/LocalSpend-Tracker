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

  /// Graph types:
  /// - total_last_week
  /// - avg_spend_last_week
  /// - total_last_month
  /// - avg_spend_last_month

  GraphData totalLastWeekGraph = new GraphData("total_last_week");
  GraphData avgSpendLastWeekGraph = new GraphData("avg_spend_last_week");
  GraphData totalLastMonthGraph = new GraphData("total_last_month");
  GraphData avgSpendLastMonth = new GraphData("avg_spend_last_month");

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

    // Initializing graphs:

    if (!totalLastWeekGraph.loaded) {
      totalLastWeekGraph.setGraphData().then((_) {
        setState(() {});
      });
    }

    if (!avgSpendLastWeekGraph.loaded) {
      avgSpendLastWeekGraph.setGraphData().then((_) {
        setState(() {});
      });
    }

    if (!totalLastMonthGraph.loaded) {
      totalLastMonthGraph.setGraphData().then((_) {
        setState(() {});
      });
    }

    if (!avgSpendLastMonth.loaded) {
      avgSpendLastMonth.setGraphData().then((_) {
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
                "Last Week's Total Spend",
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
              child: totalLastWeekGraph.graph != null ? new charts.TimeSeriesChart(totalLastWeekGraph.graph) : Center(child: Text("Loading graph...")), //List<Series<dynamic, DateTime>>
            ),

            Container(
              padding: EdgeInsets.fromLTRB(0.0,17,0.0,0.0),
              child : Text(
                "Last Week's Average Spend",
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
              child: avgSpendLastWeekGraph.graph != null ? new charts.TimeSeriesChart(avgSpendLastWeekGraph.graph) : Center(child: Text("Loading graph...")), //List<Series<dynamic, DateTime>>
            ),

            Container(
              padding: EdgeInsets.fromLTRB(0.0,17,0.0,0.0),
              child : Text(
                "Last Month's Total Spend",
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
              child: totalLastMonthGraph.graph != null ? new charts.TimeSeriesChart(totalLastMonthGraph.graph) : Center(child: Text("Loading graph...")), //List<Series<dynamic, DateTime>>
            ),

            Container(
              padding: EdgeInsets.fromLTRB(0.0,17,0.0,0.0),
              child : Text(
                "Last Month's Average Spend",
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
              child: avgSpendLastMonth.graph != null ? new charts.TimeSeriesChart(avgSpendLastMonth.graph) : Center(child: Text("Loading graph...")), //List<Series<dynamic, DateTime>>
            ),

          ],
        ),
      ),
    );
  }
}
