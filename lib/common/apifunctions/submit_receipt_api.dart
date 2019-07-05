import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_spend/common/functions/show_dialog_single_button.dart';
import 'package:local_spend/model/json/login_model.dart';
import 'package:local_spend/config.dart';
// debug
import 'package:flutter/foundation.dart';

class Receipt {
  var amount = "";
  var time = "";
  var street = "";
  var category = "";
  var organisationName = "";
  var postcode = "";
  var recurring = "";
  var town = "";

  var essential = "false";
}

Future<LoginModel> submitReceiptAPI(
    BuildContext context, Receipt receipt) async {
  //var apiUrl = ConfigWrapper.of(context).apiKey;
  final url = "https://dev.peartrade.org/api/upload";

  SharedPreferences preferences = await SharedPreferences.getInstance();

  Map<String, String> body = {
    'transaction_type' : "3",
    'transaction_value': receipt.amount,
    'purchase_time': receipt.time,
    'category': receipt.category,
    'essential': receipt.essential,
    'organisation_name': receipt.organisationName,
    'recurring': receipt.recurring,
    'street_name': receipt.street,
    'postcode': receipt.postcode,

    'town': receipt.town,

    'session_key': preferences.get('LastToken'),
  };

  debugPrint('$body');
  debugPrint(json.encode(body));

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
//      "You may have supplied an invalid 'Email' / 'Password' combination. Please try again or email an administrator.",
        responseJson.toString(),
        "OK");
    return null;
  }
}
