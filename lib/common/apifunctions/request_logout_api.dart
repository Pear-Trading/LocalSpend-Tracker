import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:local_spend/common/functions/get_token.dart';
import 'package:local_spend/common/functions/save_logout.dart';
import 'package:local_spend/model/json/login_model.dart';

Future<LoginModel> requestLogoutAPI(BuildContext context) async {
  final url = "https://dev.peartrade.org/api/logout";

  var token;

  await getToken().then((result) {
    token = result;
  });

  final response = await http.post(
    url,
    headers: {HttpHeaders.authorizationHeader: "Token $token"},
  );

  if (response.statusCode == 200) {
    saveLogout();
    return null;
  } else {
    debugPrint("Logout unsuccessful: " + response.body);

    saveLogout();
    return null;
  }
}
