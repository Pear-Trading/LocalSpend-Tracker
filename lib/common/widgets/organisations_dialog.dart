import 'package:flutter/material.dart';
import 'dart:async';

import 'package:local_spend/common/apifunctions/find_organisations.dart';

class FindOrganisations extends StatefulWidget {
  @override
  _FindOrganisationsState createState() => _FindOrganisationsState();
}

class _FindOrganisationsState extends State<FindOrganisations> {
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

//  Future<Organisation> dialog(context) {
  TextEditingController searchBarText = new TextEditingController();
  var listTitle = "Favourites";

  void _submitSearch(String search) {
    listTitle = "Results for \'" + search + "\'";
    debugPrint("Searched for \'" + search + "\'");
  }

  Widget build(BuildContext context) {
    var favourites = getFavourites();

    return SimpleDialog(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
          child: Row(
            children: <Widget>[
              Container(
                width: 200,
                height: 50,
                child: TextField(
                  controller: searchBarText,
                  decoration: InputDecoration(
                    hintText: "Payee Name",
                  ),
                  onSubmitted: (_) {
                    _submitSearch(searchBarText.text);
                  },
                ),
              ),
              Container(
                width: 80,
                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: RaisedButton(
                  onPressed: () {
                    _submitSearch(searchBarText.text);
                  },
                  child: Icon(Icons.search, color: Colors.white),
                  color: Colors.blue,
                  // make inactive when search in progress as activity indicator
                ),
              ),
            ],
          ),
        ),

        Container(
          padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
          child: Text(
            listTitle,
            style: new TextStyle(
                fontSize: 23, fontWeight: FontWeight.bold),
          ),
        ),

        Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          width: MediaQuery
              .of(context)
              .size
              .width * 0.7,
          height: MediaQuery
              .of(context)
              .size
              .height * 0.67,

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
  }
}