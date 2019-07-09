import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_spend/common/apifunctions/request_login_api.dart';
import 'package:local_spend/common/functions/show_dialog_single_button.dart';
import 'package:local_spend/common/platform/platform_scaffold.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

const URL = "https://flutter.io/";

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController(/*text: 'test@example.com'*/); // remove
  final TextEditingController _passwordController = TextEditingController(/*text: 'abc123'*/);        // remove

  FocusNode focusNode;  // added so focus can move automatically

  Future launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: true, forceWebView: true);
    } else {
      showDialogSingleButton(
          context,
          "Unable to reach your website.",
          "Currently unable to reach the website $URL. Please try again at a later time.",
          "OK");
    }
  }

  @override
  void initState() {
    super.initState();
    _saveCurrentRoute("/LoginPage");

    focusNode = FocusNode();
  }

  @override
  void dispose() {
    focusNode.dispose(); //disposes focus node when form disposed
    super.dispose();
  }

  _saveCurrentRoute(String lastRoute) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('LastPageRoute', lastRoute);
  }

  void login(String username, String password) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    requestLoginAPI(context, username,
        password);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (Navigator.canPop(context)) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/HomePage', (Route<dynamic> route) => false);
        } else {
          Navigator.of(context).pushReplacementNamed('/HomePage');
        }
      },
      child: PlatformScaffold(
//        drawer: BasicDrawer(),
//        body: Container(
//          decoration: BoxDecoration(color: Colors.white),
//          margin: const EdgeInsets.all(20),
//          child: Padding(
//            padding: EdgeInsets.fromLTRB(30.0, 170.0, 30.0, 0.0),
//            child: ListView(
//              children: <Widget>[
        body: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Container(
            margin: EdgeInsets.fromLTRB(60,0,60,0),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                      margin: EdgeInsets.fromLTRB(15,0,15,0),
//                    alignment: FractionalOffset(0.5, 0.3),  // not sure what this does ngl :/
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/launch_image.png')
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  child: TextField(
                    autocorrect: false,
                    textAlign: TextAlign.center,
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: "EMAIL",
                      hintStyle: TextStyle(fontSize: 15),
                    ),
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.bold,
                    ),
                    onSubmitted: (_) {
                      FocusScope.of(context).requestFocus(focusNode);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
                  child: TextField(
                    autocorrect: false,
                    textAlign: TextAlign.center,
                    controller: _passwordController,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      hintText: 'PASSWORD',
                      hintStyle: TextStyle(fontSize: 15),
                    ),
                    obscureText: true,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.bold,
                    ),
                    onSubmitted: (_) {
                      login( _emailController.text,
                          _passwordController.text);
                    },
                  ),
                ),
//                Padding(
//                  padding: EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 100.0),
//                  child: Container(
//                    height: 45.0,
//                    child: RaisedButton(
//
//                      onPressed: () {
//                        login( _emailController.text,
//                            _passwordController.text);
//  //                        showDialog(
//  //                          barrierDismissible: false,
//  //                        );
//  //                        print("pressed");
//                      },
//                      child: Text("GO",
//                          style:
//                          TextStyle(color: Colors.white, fontSize: 20.0)),
//                      color: Colors.blue,
//                    ),
//                  ),
//                ),
              Padding(
              padding: EdgeInsets.fromLTRB(0.0, 35.0, 0.0, 100.0),

              child : Material(
                child : InkWell(
                    onTap: () => login( _emailController.text, _passwordController.text),
                    child: new Container(
                      width: 100,
                      height: 50,
                      decoration: new BoxDecoration(
//                        color: Colors.lightBlueAccent,
                        borderRadius: new BorderRadius.circular(0.0),
                      ),
                      child: new Center(
                        child: new Text(
                            'GO', style: new TextStyle(fontSize: 18, color: Colors.white),),
                        ),
                      ),
                    splashColor: Colors.lightBlueAccent,
                    ),
                color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
