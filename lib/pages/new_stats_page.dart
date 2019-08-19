import 'package:flutter/material.dart';
import 'package:local_spend/common/platform/platform_scaffold.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_spend/common/apifunctions/get_graph_data.dart';
import 'package:charts_flutter/flutter.dart' as charts;

const URL = "https://flutter.io/";
const demonstration = false;

class NewStatsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new NewStatsPageState();
  }
}

class NewStatsPageState extends State<NewStatsPage> {

  /// Graph types:
  /// - total_last_week
  /// - avg_spend_last_week
  /// - total_last_month
  /// - avg_spend_last_month

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

      ),
    );
  }
}
