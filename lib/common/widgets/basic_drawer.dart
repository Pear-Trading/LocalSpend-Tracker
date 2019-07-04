import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_spend/common/apifunctions/request_logout_api.dart';
import 'package:local_spend/common/functions/get_token.dart';
// debug
import 'package:flutter/foundation.dart';

class BasicDrawer extends StatefulWidget {
  @override
  _BasicDrawerState createState() => _BasicDrawerState();
}

class _BasicDrawerState extends State<BasicDrawer> {
  var token;
  // TODO: add getter with getToken to check logged in

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        padding: new EdgeInsets.all(32.0),
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text (
                "Home",
                style: TextStyle(color: Colors.black, fontSize: 20.0),
              ),
              onTap: () {
                Navigator.of(context).pushNamed('/HomePage');
    }
            ),
            ListTile(
              title: Text(
                "Submit Receipt",
                style: TextStyle(color: Colors.black, fontSize: 20.0),
              ),
              onTap: () {
                debugPrint('$token');
                Navigator.of(context).pushNamed('/ReceiptPage');
              },
              // enabled: token != null && token.isNotEmpty,
            ),
            ListTile(
              title: Text(
                "About",
                style: TextStyle(color: Colors.black, fontSize: 20.0),
              ),
              onTap: () {
                SystemChannels.textInput.invokeMethod('TextInput.hide');
                Navigator.of(context).pushReplacementNamed('/AboutPage');
              },
            ),
            ListTile(
              title: Text(
                "Logout",
                style: TextStyle(color: Colors.black, fontSize: 20.0),
              ),
              onTap: () {
                requestLogoutAPI(context);
                Navigator.of(context).pushReplacementNamed('/LoginPage');
              },
            ),
          ],
        ),
      ),
    );
  }
}
