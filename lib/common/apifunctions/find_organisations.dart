import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:local_spend/common/functions/get_token.dart';

class Organisation {
  var id = 0;
  var name = "";
  var postcode = "";
  var streetName = "";  //street_name
  var town = "";

  Organisation(
      this.id,
      this.name,
      this.postcode,
      this.streetName,
      this.town,
      );

}

class Organisations {

  List<Organisation> getTestData() {
    var numItems = 200;
    var itemsList = new List<Organisation>();

    for (int i = 0; i < numItems; i++) {
      itemsList.add(new Organisation(
        i,
        "Payee " + (i + 1).toString(),
        "eee eee",
        "yeet street",
        "Robloxia"
      ));
    }

    return itemsList;
  }

  List<Organisation> _jsonToOrganisations(String json) {
    Map decoded = jsonDecode(json);
    List<dynamic> validated = decoded['validated'];
    List<Map> organisationsMaps = new List<Map>();
    validated.forEach((element) => organisationsMaps.add(element));
    List<Organisation> organisations = new List<Organisation>();

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

    if (response.statusCode == 200) {
      //request successful
      return _jsonToOrganisations(response.body);
    } else {
      // not successful
      return null;
    }

  }
}