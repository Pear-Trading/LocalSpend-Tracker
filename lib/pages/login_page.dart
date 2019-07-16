import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_spend/common/apifunctions/request_login_api.dart';
import 'package:local_spend/common/functions/show_dialog_single_button.dart';
import 'package:local_spend/common/platform/platform_scaffold.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:local_spend/common/widgets/labeled_checkbox.dart';

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
  bool _saveLoginDetails = true;  // I am extremely sorry for the placement of this variable
                                  // it will be fixed soon I promise

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

    _fillLoginDetails();
  }

  @override
  void dispose() {
    focusNode.dispose(); //disposes focus node when form disposed
    super.dispose();
  }

  _fillLoginDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var username = await preferences.get('username');
    var password = await preferences.get('password');

    _emailController.text = await username;
    _passwordController.text = await password;
  }

  _saveCurrentRoute(String lastRoute) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('LastPageRoute', lastRoute);
  }

  login(String username, String password) async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    SharedPreferences preferences = await SharedPreferences.getInstance();

    if (_saveLoginDetails) {
      await preferences.setString('username', username);
      await preferences.setString('password', password);
      print("details saved");
    } else {
      await preferences.setString('username', "");
      await preferences.setString('password', "");
      print("details cleared");
    }

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
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
              colors: [Colors.white, Colors.blue[50]],
              stops: [0,1],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),          child: Container(
            margin: EdgeInsets.fromLTRB(60,30,60,0),
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

              Padding(
              padding: EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 30.0),

              child : Material(
                child: new Container(
                  child : InkWell(
                    onTap: () => login( _emailController.text, _passwordController.text),
                    child: new Container(
                      width: 100,
                      height: 50,
                      child: new Center(
                        child: new Text(
                            'GO', style: new TextStyle(fontSize: 18, color: Colors.white),),
                        ),
                      ),
                      splashColor: Colors.lightBlueAccent,
                    ),

                  decoration: new BoxDecoration(
                    border: new Border.all(color : Colors.transparent, width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                    gradient: new LinearGradient(
                      colors: [
                        Colors.blue[300],
                        Colors.blue[500],
                      ],
                      stops: [0,1],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  ),
                ),
              ),

                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 50),

                  child: LabeledCheckbox(
                    label : "SAVE LOGIN",
                    textStyle: TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.bold),
                    padding: const EdgeInsets.fromLTRB(0,0,0,0),
                    value : _saveLoginDetails,

                    onChanged: (bool newValue) {
                      setState(() {
                        _saveLoginDetails = newValue;
                      });
                    },
                  ),

                  /*child: LabeledCheckboxWithIcon(
                    label : "SAVE LOGIN",
                    textStyle: TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.bold),
                    icon: Icons.account_box,  // need to remove icon padding!!
                    iconSize: 18,
                    iconColor: Colors.black54,
                    padding: const EdgeInsets.fromLTRB(0,0,0,0),
                    value : _saveLoginDetails,

                    onChanged: (bool newValue) {
                      setState(() {
                        _saveLoginDetails = newValue;
                      });
                    },
                  ),*/
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
