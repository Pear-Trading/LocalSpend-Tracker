import 'package:local_spend/model/json/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

saveCurrentLogin(Map responseJson, loginEmail) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  var user;
  if ((responseJson != null && responseJson.isNotEmpty)) {
    user = LoginModel.fromJson(responseJson).userName;
  } else {
    user = "";
  }
  var token = (responseJson != null && responseJson.isNotEmpty)
      ? LoginModel.fromJson(responseJson).token
      : "";
  var email = (loginEmail != null)
      ? loginEmail
      : "";
  var userType = (responseJson != null && responseJson.isNotEmpty)
      ? LoginModel.fromJson(responseJson).userType
      : "";

  await preferences.setString(
      'LastUser', (user != null && user.length > 0) ? user : "");
  await preferences.setString(
      'LastToken', (token != null && token.length > 0) ? token : "");
  await preferences.setString(
      'LastEmail', (email != null && email.length > 0) ? email : "");
  await preferences.setString(
      'LastUserType', (userType != null && userType.length > 0) ? userType : "");
}
