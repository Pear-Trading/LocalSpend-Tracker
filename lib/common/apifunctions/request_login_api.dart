import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:local_spend/common/functions/save_current_login.dart';
import 'package:local_spend/common/functions/show_dialog_single_button.dart';
import 'package:local_spend/model/json/login_model.dart';
import 'package:local_spend/config.dart';
// debug
import 'package:flutter/foundation.dart';

Future<LoginModel> requestLoginAPI(
    BuildContext context, String email, String password) async {
  //var apiUrl = ConfigWrapper.of(context).apiKey;
  final url = "https://dev.peartrade.org/api/login";

  Map<String, String> body = {
    'email': email,
    'password': password,
  };

  debugPrint('$body');

  final response = await http.post(
    url,
    body: json.encode(body),
  );

  debugPrint(response.body);

  if (response.statusCode == 200) {
    final responseJson = json.decode(response.body);
    var user = new LoginModel.fromJson(responseJson);

    saveCurrentLogin(responseJson, body["email"]);
    Navigator.of(context).pushReplacementNamed('/HomePage');

    return LoginModel.fromJson(responseJson);
  } else {
    debugPrint("Invalid, either creds are wrong or server is down");
    Navigator.of(context).pushReplacementNamed('/HomePage'); // just here temporarily while server is down

    final responseJson = json.decode(response.body);

    saveCurrentLogin(responseJson, body["email"]);
    showDialogSingleButton(
        context,
        "Unable to Login",
        "You may have supplied an invalid 'Email' / 'Password' combination. Please try again or email an administrator.",
        "OK");
    return null;
  }
}
