import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:local_spend/common/functions/get_token.dart';
import 'package:local_spend/common/functions/save_logout.dart';
import 'package:local_spend/model/json/login_model.dart';

Future<LoginModel> requestLogoutAPI(BuildContext context) async {
  final url = "https://dev.localspend.co.uk/api/logout";

  var token;

  await getToken().then((result) {
    token = result;
  });

  Map<String, String> body = {
    "Token":token,
  };

  final response = await http.post(
    url,
    body: json.encode(body),
  );

  if (response.statusCode == 200) {
//    debugPrint("Logout successful: " + response.body);

    saveLogout();
    return null;
  } else {
//    debugPrint("Logout unsuccessful: " + response.body);

    saveLogout();
    return null;
  }
}
