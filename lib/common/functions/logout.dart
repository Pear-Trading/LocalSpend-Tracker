import 'package:flutter/material.dart';
import 'package:local_spend/common/apifunctions/request_logout_api.dart';

logout(context) {
  requestLogoutAPI(context);
  Navigator.of(context).pushReplacementNamed('/LoginPage');
}