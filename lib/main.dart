import 'package:flutter/material.dart';
import 'package:local_spend/pages/home_page.dart';
import 'package:local_spend/pages/login_page.dart';
import 'package:local_spend/pages/map_page.dart';
import 'package:local_spend/pages/receipt_page_2.dart';
import 'package:local_spend/pages/spash_screen.dart';
import 'package:local_spend/pages/more_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:local_spend/common/apifunctions/get_graph_data.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() {
  runApp(
      MyApp()
  );
}

void loadGraphs() {}

class GraphWithTitle {
  GraphWithTitle({this.graph, this.title});

  GraphData graph;
  String title;
}

class MyApp extends StatelessWidget {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  @override
  Widget build(BuildContext context) {
    // TODO: load graphs on app login and send to graph widgets

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch: $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume: $message');
      },
    );

    // Required on iOS; non-op on Android.
    _firebaseMessaging.requestNotificationPermissions();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [Locale('en')],
      title: 'Local Spend Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      routes: <String, WidgetBuilder>{
        '/HomePage': (BuildContext context) => HomePage(),
        '/LoginPage': (BuildContext context) => LoginPage(),
        '/MapPage': (BuildContext context) => MapPage(),
        '/ReceiptPage': (BuildContext context) => ReceiptPage2(),
        '/MorePage': (BuildContext context) => MorePage(),
      },
      home: SplashScreen(),
    );
  }
}
