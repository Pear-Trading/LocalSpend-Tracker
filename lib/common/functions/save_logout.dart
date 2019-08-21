import 'package:shared_preferences/shared_preferences.dart';

void saveLogout() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  await preferences.setString('LastUser', "");
  await preferences.setString('LastToken', "");
  await preferences.setString('LastEmail', "");
}
