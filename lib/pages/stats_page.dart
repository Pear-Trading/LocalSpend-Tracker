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
import 'package:local_spend/common/widgets/awesome_drawer.dart';

const URL = "https://flutter.io/";
const demonstration = false;

class StatsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new StatsPageState();
  }
}

class StatsPageState extends State<StatsPage> {

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
    var drawer = new AwesomeDrawer();

    return PlatformScaffold(
      drawer: drawer.getDrawer(context),

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
            // some graphs and charts here etc
//            Container(
//              padding: EdgeInsets.fromLTRB(0.0,17,0.0,0.0),
//              child : Text(
//                "Really Cool Chart",
//                textAlign: TextAlign.center,
//                style: TextStyle(
//                  fontSize: 22.0,
//                  color: Colors.black,
//                  fontWeight: FontWeight.bold,
//                ),
//              ),
//            ),
//
//            Container(
//              height: 250,
////              width: 250,
//              child: new DonutPieChart.withSampleData()
//            ),

            Container(
              padding: EdgeInsets.fromLTRB(0.0,17,0.0,0.0),
              child : Text(
                "GroupedBarChart",
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
              child: new GroupedBarChart.withSampleData()
            ),

            Container(
              padding: EdgeInsets.fromLTRB(0.0,17,0.0,0.0),
              child : Text(
                "BucketingAxisScatterPlotChart",
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
                child: new BucketingAxisScatterPlotChart.withSampleData()
            ),

            Container(
              padding: EdgeInsets.fromLTRB(0.0,20,0.0,0.0),
              child : Text(
                "PieOutsideLabelChart",
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
                child: new PieOutsideLabelChart.withSampleData()
            ),

            Container(
              padding: EdgeInsets.fromLTRB(0.0,17,0.0,0.0),
              child : Text(
                "DonutAutoLabelChart",
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
                child: new DonutAutoLabelChart.withSampleData()
            ),

            Container(
              padding: EdgeInsets.fromLTRB(0.0,17,0.0,0.0),
              child : Text(
                "DonutPieChart",
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
                child: new DonutPieChart.withSampleData()
            ),

            Container(
              padding: EdgeInsets.fromLTRB(0.0,17,0.0,0.0),
              child : Text(
                "NumericComboLineBarChart",
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
                child: new NumericComboLineBarChart.withSampleData()
            ),

            Container(
              padding: EdgeInsets.fromLTRB(0.0,17,0.0,0.0),
              child : Text(
                "LegendWithMeasures",
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
                child: new LegendWithMeasures.withSampleData()
            ),

          ],
        ),
      ),
    );
  }
}
