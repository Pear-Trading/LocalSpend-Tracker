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

  // todo: get all organisations, favourites and all data from one 'organisations' class or similar
  // eg items: organisations.getFavourites().orderBy(name),

  Future<Organisation> dialog(context) {
    TextEditingController searchBarText = new TextEditingController();
    var organisations = new Organisations();
    var listTitle = "All Organisations";
    var organisationsList = organisations.getTestData();

    void _submitSearch(String search) {
      listTitle = "Results for \'" + search + "\'";

      var futureOrgs = organisations.findOrganisations(search);
      futureOrgs.then((val) {
        debugPrint("There are " + val.length.toString() +
            " payees matching the query \'" + search + "\'.");
        organisationsList = val;
      });
    }

    return showDialog<Organisation>(
      context: context,
      barrierDismissible: true,

      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SimpleDialog(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Row(
                    children: [
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
                            setState(() => {});
                          },
                        ),
                      ),

                      Container(
                        width: 80,
                        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: RaisedButton(
                          onPressed: () {
                            _submitSearch(searchBarText.text);
                            setState(() => {});
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
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
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
                      itemCount: organisationsList.length,
                      itemBuilder: (context, index) {
                        return Card(
                            child: ListTile(
                              leading: Icon(Icons.person),
                              title: Text(organisationsList[index].name, style: new TextStyle(fontSize: 18)),
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
      },
    );
  }
}