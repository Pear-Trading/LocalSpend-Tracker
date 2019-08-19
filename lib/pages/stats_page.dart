import 'package:flutter/material.dart';
import 'package:local_spend/common/platform/platform_scaffold.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_spend/pages/customerGraphs.dart';
import 'package:local_spend/pages/orgGraphs.dart';

const URL = "https://flutter.io/";
const demonstration = false;

class StatsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new StatsPageState();
  }
}

class StatsPageState extends State<StatsPage> {
  String userType = "-";

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

  Future<String> _getUserType() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.get('LastUserType');
  }

  @override
  Widget build(BuildContext context) {
    if (userType == "-") {
      _getUserType().then((value) {
        print(value);
        userType = '${value[0].toUpperCase()}${value.substring(1)}'; // capitalises first letter
        setState(() {});
      });
    }

    return PlatformScaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Statistics",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 7)
            ),

            Text(
              "User type: " + userType,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white70,
              ),
            ),
          ],
        ),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
        ),


      body : Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: (userType == "-" ? null : (userType.toLowerCase() == "customer" ? CustomerGraphs() : OrgGraphs())),
      ),
    );
  }
}
