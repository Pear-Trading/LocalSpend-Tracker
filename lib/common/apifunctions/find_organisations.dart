import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:local_spend/common/functions/get_token.dart';

class Organisation {
  var id = 0;
  var name = "";
  var postcode = "";
  var streetName = "";  //street_name
  var town = "";

  Organisation(int id, String name, String postcode, String streetName, String town) {
    this.id = id;
    this.name = name;
    this.postcode = postcode;
    this.streetName = streetName; //street_name
    this.town = town;
  }

}

List<Organisation> jsonToOrganisations(String json) {
  Map decoded = jsonDecode(json);
//  print(decoded);

  List<dynamic> validated = decoded['unvalidated'];
//  Map organisation = validated[0];

  print("");
  print("Response:");
  for (var i = 0; i < validated.length; i++) {
    print(validated[i]);
  }

  List<Map> organisationsMaps = new List<Map>();

  validated.forEach((element) => organisationsMaps.add(element));

//  print("");
//  print("organisationsMaps:");
//  print(organisationsMaps);

  List<Organisation> organisations = new List<Organisation>();
  
//  organisationsMaps[0].forEach((k,v) => print('${k}: ${v}'));

  for (var i = 0; i < organisationsMaps.length; i++) {
    final params = organisationsMaps[i].values.toList();

    var newOrganisation = new Organisation(
      params[0].toInt(),
      params[1].toString(),
      params[2].toString(), // oof
      params[3].toString(), // this could be improved...
      params[4].toString(),
    );

    organisations.add(newOrganisation);
  }

  // the reason some organizations do not show up is because they are not all validated
  // option to 'show unvalidated' should be added along with maybe a settings section

  print("");
  print("Local:");
  for (var i = 0; i < organisations.length; i++)
    {
      print(organisations[i].name);
    }
  print("");

  return organisations;
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

//  print(response.body);

  if (response.statusCode == 200) {
    //request successful
    return jsonToOrganisations(response.body);
  } else {
    // not successful
    return null;
  }

}