
import 'package:flutter/material.dart';
import 'package:local_spend/common/platform/platform_scaffold.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_spend/common/functions/logout.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:local_spend/common/functions/customAbout.dart' as custom;
import 'package:local_spend/common/functions/showDialogTwoButtons.dart';

const URL = "https://flutter.io/";
const demonstration = false;

class MorePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MorePageState();
  }
}

class MorePageState extends State<MorePage> {
  FocusNode focusNode;  // added so focus can move automatically

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

  _saveCurrentRoute(String lastRoute) async {
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
                padding: EdgeInsets.fromLTRB(30.0,25,30.0,0.0),
                child : Text(
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
                        children: <Widget>
                        [
                          Text("Pear Trading is a commerce company designed to register and monitor money circulating in the local economy.\n"),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            height: 35,
                            child: RaisedButton(
                              onPressed: () => {},
                              child: Text("Contact us",
                                  style:
                                  TextStyle(color: Colors.white, fontSize: 18.0)),
                              color: Colors.green,
                            ),
                          ),

                          Container(
                            height: 35,
                            margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
                            child: RaisedButton(
                              child: Text
                                ('Pear Trading',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0
                                ),
                              ),
                              color: Colors.lightGreen,
                              onPressed: () => launch('http://www.peartrade.org')
                            ),
                          ),

                          Container(
                            height: 35,
                            margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
                            child: Material(
                              child: OutlineButton(
                                child: Text
                                  ('Shadowcat Systems',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0                    /// I don't know what to do with this button
                                  ),
                                ),
                                onPressed: () => launch('https://shadow.cat/'),
                              ),
                              color: Colors.lightGreenAccent,
                              shadowColor: Colors.transparent,
                            ),
                          ),

                        ],
                      );

                    },
                    child: Text("ABOUT",
                        style:
                        TextStyle(color: Colors.white, fontSize: 22.0)),
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
                        logout
                      );
                    },
                    child: Text("LOGOUT",
                        style:
                        TextStyle(color: Colors.white, fontSize: 22.0)),
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
