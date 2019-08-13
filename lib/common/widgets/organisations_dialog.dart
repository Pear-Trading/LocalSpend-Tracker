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

  Future<dynamic> _moreInfoDialog(context, Organisation organisation) {
    TextStyle informationTitleStyle = new TextStyle(fontSize: 16);
    TextStyle informationStyle = new TextStyle(fontSize: 16, fontWeight: FontWeight.bold);

    return showDialog<Organisation>(
      context: context,
      barrierDismissible: true,

      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SimpleDialog(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Text(
                    organisation.name,
                    style: new TextStyle(
                        fontSize: 21, fontWeight: FontWeight.bold),
                  ),
                ),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Divider(),
                ),

                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Table(
//                    defaultColumnWidth: FixedColumnWidth(100),
                    children: [
                      TableRow(
                        children: [
                          Text("Street:", style: informationTitleStyle),
                          Text(organisation.streetName, style: informationStyle),
                        ],
                      ),
                      TableRow(
                        children: [
                          Text("Postcode:", style: informationTitleStyle),
                          Text(organisation.postcode.toUpperCase(), style: informationStyle),
                        ],
                      ),
                      TableRow(
                        children: [
                          Text("Town:", style: informationTitleStyle),
                          Text(organisation.town, style: informationStyle),
                        ],
                      ),
                    ],
                  ),
                ),

              ],
            );
          },
        );
      },
    );
  }

  Future<Organisation> dialog(context) {
    bool _searchEnabled = false;
    TextEditingController searchBarText = new TextEditingController();
    var organisations = new Organisations();
    var listTitle = "All Organisations";
//    var organisationsList = organisations.getTestData();
    var organisationsList = List<Organisation>();

    Future<int> _submitSearch(String search) async {
      _searchEnabled = false;
      listTitle = "Results for \'" + search + "\'";

      var futureOrgs = await organisations.findOrganisations(search);
//      futureOrgs.then((value) {
//        debugPrint("There are " + futureOrgs.length.toString() +
//            " payees matching the query \'" + search + "\'.");
        organisationsList = futureOrgs;
        _searchEnabled = true;
        return futureOrgs.length;
//      });
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
                        width: 140,
                        height: 50,
                        child: TextField(
                          controller: searchBarText,
                          decoration: InputDecoration(
                            hintText: "Payee Name",
                          ),
                          onChanged: (value) {
                            if (value.length > 0) {
                              _searchEnabled = true;
                            } else {
                              _searchEnabled = false;
                            }
                            setState(() => {_searchEnabled});
                          },
                          onSubmitted: (_) {
                            if (_searchEnabled) {
                              var result = _submitSearch(searchBarText.text);
                              result.then((_) {
                                setState(() {});
                              });
                            }
                          },
                        ),
                      ),

                      Container(
                        width: 80,
                        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),

                        child: RaisedButton(
                          onPressed: (() {
                            if (_searchEnabled) {
                              var result = _submitSearch(searchBarText.text);
                              result.then((_) {
                                setState(() {});
                              });
                            }
                          }),

                          child: Icon(Icons.search, color: Colors.white),
                          color: _searchEnabled ? Colors.blue : Colors.blue[200],
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
                      .width,
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
                            subtitle: Text(organisationsList[index].postcode.toUpperCase()),
//                            trailing: Icon(Icons.arrow_forward_ios),
//                            onTap: _chosenOrg(organisationsList[index]),
                            onTap: (){
                              Navigator.of(context).pop(organisationsList[index]);
                            },
                            onLongPress: (){
                              // show more details about the organisation in a new dialog
                              var moreInfo = _moreInfoDialog(context, organisationsList[index]);
                              moreInfo.whenComplete(null);
                            },
                          ),
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