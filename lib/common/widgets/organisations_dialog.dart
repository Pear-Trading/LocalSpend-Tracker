import 'package:flutter/material.dart';
import 'dart:async';

import 'package:local_spend/common/apifunctions/find_organisations.dart';

class FindOrganisations {

  TextField getSearchBar(TextEditingController controller, String hintText) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        icon: Icon(Icons.search),
      ),
    );
  }

  List<Text> getFavourites() {
    var numItems = 200;
    var itemsList = new List<Text>();

    for (int i = 0; i < numItems; i++) {
      itemsList.add(Text(
        "Payee " + (i + 1).toString(),
        style: new TextStyle(fontSize: 18),
      ));
    }

    return itemsList;
  }

  // todo: get all organisations, favourites and all data from one 'organisations' class or similar
  // eg items: organisations.getFavourites().orderBy(name),

  Future<Organisation> dialog(context) {
    var searchBar = getSearchBar(null, "Payee Name");
    var favourites = getFavourites();
    return showDialog<Organisation>(
      context: context,
      barrierDismissible: true,

      builder: (BuildContext context) {
        return SimpleDialog(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: searchBar,
            ),

            Container(
              padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
              child: Text(
                "Favourites",
                style: new TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
            ),

            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.height * 0.67,

              child: Material(
                shadowColor: Colors.transparent,
                color: Colors.transparent,
                child: ListView.builder(
                  itemCount: favourites.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        leading: Icon(Icons.person),
                        title: favourites[index],
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {},
                      )
                    );
                  },
                ),
              ),
            ),


            // help button for if org not listed
            // cancel and ok buttons

          ],
        );
      },
    );
  }
}