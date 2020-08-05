import 'package:flutter/material.dart';
import 'package:local_spend/common/platform/platform_scaffold.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_spend/common/functions/logout.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:local_spend/common/functions/customAbout.dart' as custom;
import 'package:local_spend/common/functions/showDialogTwoButtons.dart';

const url = "https://flutter.io/";
const demonstration = false;

class MorePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MorePageState();
  }
}

class MorePageState extends State<MorePage> {
  FocusNode focusNode; // added so focus can move automatically

  DateTime date;

  @override
  void initState() {
    super.initState();
    _saveCurrentRoute("/MorePageState");

    focusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();

    focusNode.dispose(); //disposes focus node when form disposed
  }

  void _saveCurrentRoute(String lastRoute) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('LastPageRoute', lastRoute);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (Navigator.canPop(context)) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/LoginPage', (Route<dynamic> route) => false);
        } else {
          Navigator.of(context).pushReplacementNamed('/LoginPage');
        }
        return null;
      },
      child: PlatformScaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[400],
          title: Text(
            "More",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
//          leading: BackButton(),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: Container(
          child: ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(30.0, 25, 30.0, 0.0),
                child: Text(
                  "Local Spend Tracker",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(30.0, 25.0, 30.0, 0.0),
                child: Container(
                  height: 65.0,
                  child: RaisedButton(
                    onPressed: () {
                      custom.showAboutDialog(
                        context: context,
                        applicationIcon: new Icon(Icons.receipt),
                        applicationName: "Local Spend Tracker",
                        children: <Widget>[
                          Text("Pear Trading is a commerce company designed to register and monitor money circulating in the local economy.\n"),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            height: 35,
                            child: RaisedButton(
                              onPressed: () => launch('http://www.peartrade.org'),
                              child: Text("Pear Trading",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18.0)),
                              color: Colors.green,
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                            height: 40.0,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(3),
                                onTap: () => launch('https://shadow.cat'),
                                child: Column(
                                  children: [
                                    Align(
                                        child: Text("Developed by"),
                                        alignment: Alignment.centerLeft),
                                    Container(
                                      margin: EdgeInsets.all(0),
                                      child : Text(
                                        "Shadowcat Systems",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                        ],
                      );
                    },
                    child: Text("ABOUT",
                        style: TextStyle(color: Colors.white, fontSize: 22.0)),
                    color: Colors.blue,
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0.0),
                child: Container(
                  height: 65.0,
                  child: RaisedButton(
                    onPressed: () {
                      showDialogTwoButtons(
                          context,
                          "Logout",
                          "Are you sure you want to log out?",
                          "Cancel",
                          "Logout",
                          logout);
                    },
                    child: Text("LOGOUT",
                        style: TextStyle(color: Colors.white, fontSize: 22.0)),
                    color: Colors.red,
                  ),
                ),
              ),

//              Padding(
//                padding: EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0.0),
//                child: Container(
//                  height: 65.0,
//                  child: RaisedButton(
//                    onPressed: () {
//                      feedback(context);
//                    },
//                    child: Text("FEEDBACK",
//                        style:
//                        TextStyle(color: Colors.white, fontSize: 22.0)),
//                    color: Colors.green,
//                  ),
//                ),
//              ),
            ],
          ),
        ),
      ),
    );
  }
}
