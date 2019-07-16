import 'package:flutter/material.dart';
import 'package:local_spend/common/apifunctions/request_logout_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

logout(context) {
  requestLogoutAPI(context);
  Navigator.of(context).pushReplacementNamed('/LoginPage');
  _clearLoginDetails();
}

_clearLoginDetails() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  preferences.setString('username', "");
  preferences.setString('password', "");
  print("details cleared");
}