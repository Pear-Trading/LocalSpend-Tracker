import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:local_spend/common/functions/get_token.dart';
import 'package:local_spend/common/functions/save_logout.dart';

Future<bool> requestLogoutAPI() async {
  saveLogout();

  final url = "https://dev.localspend.co.uk/api/logout";

  var token;

  await getToken().then((result) {
    token = result;
  });

  Map<String, String> body = {
    "Token": token,
  };

  await http.post(
    url,
    body: json.encode(body),
  );

  return true;
}
