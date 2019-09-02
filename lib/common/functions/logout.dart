import 'package:flutter/material.dart';
import 'package:local_spend/common/apifunctions/request_logout_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

void logout(context) {
  _clearLoginDetails().then((_) {
    requestLogoutAPI();
    Navigator.of(context).pushReplacementNamed('/LoginPage');
  });
}

Future<void> _clearLoginDetails() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  await preferences.setString('username', "");
  await preferences.setString('password', "");
}
