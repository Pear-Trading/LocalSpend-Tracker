import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:local_spend/common/functions/save_current_login.dart';
import 'package:local_spend/model/json/login_model.dart';

Future<void> _incorrectDialog(BuildContext context, bool isLoginWrong) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AnimatedContainer(
        duration: Duration(seconds: 2),
        child : AlertDialog(
          title: Text("Uh-oh!"),
          content: Text(isLoginWrong ? "Incorrect login details. Please try again." : "Our servers are having issues at the moment; sorry for the inconvenience. Please try again later."),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    },
  );
}

Future<LoginModel> requestLoginAPI(BuildContext context, String email, String password) async {
  final url = "https://dev.localspend.co.uk/api/login";

  Map<String, String> body = {
    'email': email,
    'password': password,
  };

//  debugPrint('$body');

  try {
    final response = await http.post(
      url,
      body: json.encode(body),
    ).timeout(Duration(seconds: 5));

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
  } on TimeoutException catch (_) {
    _incorrectDialog(context, false);
  } catch (error) {
    debugPrint(error.toString());
    _incorrectDialog(context, false);
  }
}

