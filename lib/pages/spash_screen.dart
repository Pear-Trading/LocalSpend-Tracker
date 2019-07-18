import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_spend/common/platform/platform_scaffold.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final int splashDuration = 1;

  startTime() async {
    return Timer(Duration(seconds: splashDuration), () {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      Navigator.of(context).pushReplacementNamed('/LoginPage');
    });
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    var drawer = Drawer();

    return PlatformScaffold(
        drawer: drawer,
        body: Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(15),
                    alignment: FractionalOffset(0.5, 0.3),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/launch_image.png')
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 30.0),
                  child: Text(
                    "© Copyright Statement 2019",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            )));
  }
}
