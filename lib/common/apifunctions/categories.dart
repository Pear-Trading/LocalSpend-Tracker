import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:local_spend/common/functions/get_token.dart';
import 'package:flutter/material.dart';

Future<List<String>> getCategories() async {
  const url = "https://dev.peartrade.org/api/search/category";
  var token;

  await getToken().then((result) {
    token = result;
  });

  Map<String, String> body = {
    "session_key":token,
  };

  final response = await http.post (
    url,
    body: json.encode(body),
  );

//  print(response.body);

  if (response.statusCode == 200) {
    //request successful
    List<String> categories = new List<String>();
    Map responseMap = json.decode(response.body);

    var categoriesJSON = responseMap['categories'];

    //nice.
    // so the response needs to be decoded iteratively, like
    // categories.add(new Category(name: categoriesJSON[i.toString()], index: i.toString()));

//    print(categoriesJSON['11']); // prints "Banana"

    int i = 1;  // starts on 1. that was annoying to debug!
    while (true) {

      if (categoriesJSON[i.toString()] != null) {
//        print("Iteration " + i.toString());
//        print(categoriesJSON[i.toString()]);
        categories.add(categoriesJSON[i.toString()]);
//        print(categories.last);
        i++;
      } else {
//        print("Number of categories: " + (i - 1).toString());
//        print("categoriesJSON[" + i.toString() + ".toString()] == null");
        break;
      }
    } // does this until error, which then tells it that there is no more JSON left

//    print(categories[11].name);

//    decodedResponse.forEach((key, value) {
////      print(key + ": " + value);
//      categories.add(new Category(name: value, index: key));
//    });

//    print(categories[10].name.toString());  // prints "Banana"

    return categories;  // categories is List<Category>
    // Category is defined at the top^^
  } else {
    // not successful
    return null;
  }
}