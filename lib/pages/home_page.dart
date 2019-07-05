import 'package:flutter/material.dart';
import 'package:local_spend/common/platform/platform_scaffold.dart';
import 'package:local_spend/common/widgets/basic_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:local_spend/common/apifunctions/request_logout_api.dart';
import 'package:local_spend/common/functions/get_token.dart';
import 'package:flutter_fadein/flutter_fadein.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override

  void initState() {
    super.initState();
    _saveCurrentRoute("/HomePage");
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
          "Navigation",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 6.0,
      ),
      drawer: BasicDrawer(),
      body: Container(
        child: FadeIn(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeIn,

          child: Column(
            children: <Widget>[

              ListTile(
                contentPadding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                title: new Center(
                  child: new Text(
                    "Submit Receipt",
                    style: TextStyle(color: Colors.black, fontSize: 20.0),
                    textAlign: TextAlign.center,
                  ),
                ),
                onTap: () {
  //                debugPrint('$token');
                  Navigator.of(context).pushNamed('/ReceiptPage');
                },
              ),

              ListTile(
                title: new Center(
                  child: new Text(
                    "About",
                    style: TextStyle(color: Colors.black, fontSize: 20.0),
                  ),
                ),
                onTap: () {
                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                  Navigator.of(context).pushReplacementNamed('/AboutPage');
                },
              ),

              ListTile(
                title: new Center(
                  child: new Text(
                    "Logout",
                    style: TextStyle(color: Colors.black, fontSize: 20.0),
                  ),
                ),
                onTap: () {
                  requestLogoutAPI(context);
                  Navigator.of(context).pushReplacementNamed('/LoginPage');
                },

              ),
            ],
          ),
        ),
      ),
    );
  }
}
