import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_spend/common/apifunctions/request_login_api.dart';
import 'package:local_spend/common/functions/show_dialog_single_button.dart';
import 'package:local_spend/common/platform/platform_scaffold.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:local_spend/common/widgets/labeled_checkbox.dart';
import 'package:local_spend/common/widgets/animatedGradientButton.dart';

const url = "https://flutter.io/";

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  bool _isLoggingIn = false;
  final TextEditingController _emailController =
      TextEditingController();
  final TextEditingController _passwordController =
      TextEditingController();
  bool _saveLoginDetails = true;

  FocusNode focusNode; // added so focus can move automatically

  Future launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: true, forceWebView: true);
    } else {
      showDialogSingleButton(
          context,
          "Unable to reach your website.",
          "Currently unable to reach the website $url. Please try again at a later time.",
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

  void _fillLoginDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var username = await preferences.get('username');
    var password = await preferences.get('password');

    _emailController.text = await username;
    _passwordController.text = await password;
  }

  void _saveCurrentRoute(String lastRoute) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('LastPageRoute', lastRoute);
  }

  void login(String username, String password) async {
    _isLoggingIn = true;
    await SystemChannels.textInput.invokeMethod('TextInput.hide');
    SharedPreferences preferences = await SharedPreferences.getInstance();

    if (_saveLoginDetails) {
      await preferences.setString('username', username);
      await preferences.setString('password', password);
    } else {
      await preferences.setString('username', ""); // this does work...
      await preferences.setString('password', ""); // ...but this doesn't seem to have any effect..?
    }

    await requestLoginAPI(context, username, password).then((value) {
      _isLoggingIn = false;
    });
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
        return null;
      },
      child: PlatformScaffold(
        body: Stack(
          children: [
            AnimatedBackground([Colors.lightBlue[50], Colors.lightBlue[50]],
                Colors.white, Alignment.topRight, Alignment.bottomLeft, 3),
            Container(
              margin: EdgeInsets.fromLTRB(60, 30, 60, 0),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: AnimatedContainer(
                      duration: Duration(seconds: 2),
                      margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image:
                                AssetImage('assets/images/launch_image.png')),
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
                        login(_emailController.text, _passwordController.text);
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 30.0),
                    width: 100,
                    height: 50,
                    child: Opacity(
                      opacity: _isLoggingIn ? 0.5 : 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: Stack(
                          children: [
                            AnimatedBackground(
                                [Colors.blue, Colors.lightBlue[300]],
                                Colors.lightBlue,
                                Alignment.bottomRight,
                                Alignment.topLeft,
                                3),
                            Material(
                              type: MaterialType.transparency,
                              child: InkWell(
                                onTap: _isLoggingIn
                                    ? null
                                    : () => login(_emailController.text,
                                        _passwordController.text),
                                child: new Center(
                                  child: new Text(
                                    'GO',
                                    style: new TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 50),
                    child: LabeledCheckbox(
                      label: "SAVE LOGIN",
                      textStyle: TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold),
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      value: _saveLoginDetails,
                      onChanged: (bool newValue) {
                        setState(() {
                          _saveLoginDetails = newValue;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
