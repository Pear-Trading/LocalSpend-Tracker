import 'package:flutter/material.dart';
import 'package:local_spend/pages/home_page.dart';
import 'package:local_spend/pages/login_page.dart';
import 'package:local_spend/pages/receipt_page.dart';
import 'package:local_spend/pages/spash_screen.dart';
import 'package:local_spend/pages/more_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:local_spend/common/apifunctions/get_graph_data.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    GraphData gd = new GraphData();
    gd.getGraphData('total_last_week');

    //var config = ConfigWrapper.of(context);
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale("en")
      ],

      title: "Local Spend Tracker",
      theme: new ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      routes: <String, WidgetBuilder>{
        "/HomePage": (BuildContext context) => HomePage(),
        "/LoginPage": (BuildContext context) => LoginPage(),
        "/ReceiptPage": (BuildContext context) => ReceiptPage(),
        "/MorePage": (BuildContext context) => MorePage(),
      },
      home: SplashScreen(),
    );
  }
}
