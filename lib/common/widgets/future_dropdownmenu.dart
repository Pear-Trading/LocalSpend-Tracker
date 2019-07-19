import 'package:flutter/material.dart';
import 'package:local_spend/common/apifunctions/categories.dart';
import 'dart:async';

Future<List<DropdownMenuItem>> getDropDownItems(String type) async {
  List<DropdownMenuItem<String>> items = new List<DropdownMenuItem<String>>();

//  if (type == "categories") {
    var categories = await getCategories();

    categories.forEach((thisValue) {
      items.add(
        new DropdownMenuItem(
          child: new Text(thisValue.name),
          value: thisValue.index,
          key: Key(thisValue.index),
        ),
      );
    });

    print("oof");

    return items;
//  }
}
