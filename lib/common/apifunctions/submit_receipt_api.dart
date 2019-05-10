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

Future<LoginModel> submitReceiptAPI(
    BuildContext context, String amount, String time) async {
  //var apiUrl = ConfigWrapper.of(context).apiKey;
  final url = "https://dev.peartrade.org/api/login";

  Map<String, String> body = {
    'transaction_value': amount,
    'purchase_time': time,
  };

  debugPrint('$body');

  final response = await http.post(
    url,
    body: json.encode(body),
  );

  debugPrint(response.body);

  if (response.statusCode == 200) {
    final responseJson = json.decode(response.body);

    return LoginModel.fromJson(responseJson);
  } else {
    final responseJson = json.decode(response.body);


    showDialogSingleButton(
        context,
        "Unable to Submit Receipt",
        "You may have supplied an invalid 'Email' / 'Password' combination. Please try again or email an administrator.",
        "OK");
    return null;
  }
}
