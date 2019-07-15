import 'package:flutter/material.dart';
import 'package:local_spend/common/platform/platform_scaffold.dart';
import 'package:local_spend/common/widgets/basic_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_linkify/flutter_linkify.dart';

class AboutPage extends StatefulWidget {
  @override
//  _HomePageState createState() => _HomePageState();
  State<StatefulWidget> createState() {
    return new _HomePageState();
  }
}

class _HomePageState extends State<AboutPage> {
  @override
  void initState() {
    super.initState();
    _saveCurrentRoute("/AboutPage");
  }

  @override
  void dispose() {
    super.dispose();
  }

  _saveCurrentRoute(String lastRoute) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('LastScreenRoute', lastRoute);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (Navigator.canPop(context)) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/HomePage', (Route<dynamic> route) => true);
        } else {
          Navigator.of(context).pushReplacementNamed('/HomePage');
        }
      },
      child: PlatformScaffold(
        appBar: AppBar(
          title: Text(
            "About Page",
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          leading: BackButton(),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
        ),
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
                  // TODO: Make this an @email link
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
                  // TODO: Make this a @phone link
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
      ),
    );
  }
}