import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:local_spend/common/functions/get_token.dart';

class Organisation {
  var id = 0;
  var name = "";
  var postcode = "";
  var street_name = "";
  var town = "";
}

List<Organisation> jsonToOrganisations(String json) {
  Map decoded = jsonDecode(json);
  print(decoded);

  List<dynamic> validated = decoded['validated'];
//  Map organisation = validated[0];

  List<Map> organisations = new List<Map>();

  validated.forEach((element) => organisations.add(element));

//  print(organisations);
}

Future<List<Organisation>> findOrganisations(String search) async {
  final url = "https://dev.peartrade.org/api/search";
  var token;

  await getToken().then((result) {
    token = result;
  });

  Map<String, String> body = {
    "search_name":search,
    "session_key":token,
  };

  final response = await http.post (
    url,
    body: json.encode(body),
  );

  print(response.body);

  if (response.statusCode == 200) {
    //request successful
    return jsonToOrganisations(response.body);
  } else {
    // not successful
    return null;
  }

}