import 'package:flutter/material.dart';
import 'package:local_spend/common/platform/platform_scaffold.dart';
import 'package:local_spend/common/widgets/basic_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_linkify/flutter_linkify.dart';

class AboutPage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<AboutPage> {
  @override
  void initState() {
    super.initState();
    _saveCurrentRoute("/AboutPage");
  }

  _saveCurrentRoute(String lastRoute) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('LastScreenRoute', lastRoute);
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: AppBar(
        title: Text(
          "About Page",
          style: TextStyle(
              fontSize: 30,
              color: Colors.black),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 6.0,
      ),
      drawer: BasicDrawer(),
      body: Container(
        padding: EdgeInsets.all(32.0),
        child: ListView(
            children: <Widget>[
              InkWell(
                  child: const Center(child: Text
                    ('Pear Trading',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.blue,
                      ),
                    ),
                  ),
                  onTap: () => launch('https://app.peartrade.org/#/login?returnUrl=%2Fdashboard')
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0,20,0,0),
                child: Text(
                  "Pear Trading is a commerce company designed to register and monitor money circulating in the local economy.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0,20,0,0),
                child: Text(
                  "Email: Test@admin.com",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.blue,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0,20,0,0),
                child: Text(
                  "Phone: +44(0)1524 64544",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.blue,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0,40,0,0),
                child: Text(
                  "Developed by Shadowcat Industries",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0,20,0,0),
                child: InkWell(
                    child: const Center(child: Text
                      ('Shadowcat',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.blue,
                        ),
                      ),
                    ),
                    onTap: () => launch('https://shadow.cat/')
                ),
              ),
            ],
        ),
      ),
    );
  }
}