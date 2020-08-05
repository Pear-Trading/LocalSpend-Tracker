import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

Future<String> getToken() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  String getToken = preferences.getString("LastToken");
  return getToken;
}
