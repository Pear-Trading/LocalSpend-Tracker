import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:local_spend/common/functions/save_current_login.dart';
import 'package:local_spend/common/functions/show_dialog_single_button.dart';
import 'package:local_spend/model/json/login_model.dart';

Future<void> _incorrectDialog(BuildContext context, bool isLoginWrong) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Unable to Login"),
        content: Text(isLoginWrong ? "Incorrect login details. Please try again." : "The server is having issues; sorry for the inconvenience. Please try again later."),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<LoginModel> requestLoginAPI(
    BuildContext context, String email, String password) async {
  //var apiUrl = ConfigWrapper.of(context).apiKey;
  final url = "https://dev.peartrade.org/api/login";

  Map<String, String> body = {
    'email': email,
    'password': password,
  };

//  debugPrint('$body');

  try {
    final response = await http.post(
      url,
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);

      saveCurrentLogin(responseJson, body["email"]);
      Navigator.of(context).pushReplacementNamed('/HomePage');

      return LoginModel.fromJson(responseJson);
    } else {
      final responseJson = json.decode(response.body);

      saveCurrentLogin(responseJson, body["email"]);

      _incorrectDialog(context, true);

      return null;
    }
  } catch (_) {
    _incorrectDialog(context, false);
  }
}

