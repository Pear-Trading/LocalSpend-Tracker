import 'package:flutter/material.dart';
import 'package:local_spend/common/platform/platform_scaffold.dart';
import 'package:intl/intl.dart';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:local_spend/common/apifunctions/find_organisations.dart';
import 'package:local_spend/common/widgets/organisations_dialog.dart';
import 'package:local_spend/common/apifunctions/submit_receipt_api.dart';
import 'package:local_spend/common/apifunctions/categories.dart';

class Transaction {
  DateTime date;
  TextEditingController amount;
  Organisation organisation;
  String recurring;
  bool isEssential;
  String category;

  Transaction(
    this.date,
    this.amount,
    this.organisation,
    this.recurring,
    this.isEssential,
    this.category,
  );
}

class ReceiptPage2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ReceiptPage2State();
  }
}

class ReceiptPage2State extends State<ReceiptPage2> {
  Transaction transaction = new Transaction(
    DateTime.now(),
    new TextEditingController(),
    new Organisation(null, null, null, null, null),
    "None",
    false,
    "Uncategorised",
  );

  _invalidDialog(context) {
    return AlertDialog(
      title: new Text("Invalid data"),
      content: new Text(
          "We couldn't process your request because some of the data entered is invalid."),
      actions: <Widget>[
        new FlatButton(
          child: new Text("OK"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Future<List<String>> getCats() async {
    return await getCategories();
  }

  _submitReceipt(Transaction transaction) {
    DateTime dt = new DateTime.now();
    // sample transaction:
    // {
    //  "transaction_type":1,
    //  "transaction_value":33,
    //  "purchase_time":"2019-08-12T11:06:00.000+01:00",
    //  "organisation_id":59661,
    //  "essential":false,
    //  "session_key":"C438432A-B775-11E9-8EE8-147589E69626"
    // }

    Receipt receipt = new Receipt();
    receipt.organisationName = transaction.organisation.name;
    receipt.street = transaction.organisation.streetName;
    receipt.postcode = transaction.organisation.postcode;
    receipt.town = transaction.organisation.town;

    receipt.recurring = transaction.recurring;

    if (transaction.recurring == "None") {
      receipt.recurring = "";
    }

    receipt.category = transaction.category;

    if (transaction.category == "Uncategorised") {
      receipt.category = "";
    }

    receipt.amount = transaction.amount.text.toString();
    receipt.time = DateFormat("yyyy-MM-dd'T'hh:mm':00.000+01:00'").format(transaction.date).toString();
    receipt.essential = transaction.isEssential.toString();

    submitReceiptAPI(context, receipt);
  }

  List<String> _sampleRecurringOptions = new List<String>(7);
  List<String> _categories = new List<String>();

  @override
  Widget build(BuildContext context) {

    if (_categories.length == 0) {
      Future<List<String>> _futureCats = getCats();
      _categories.add("Fetching categories...");
      _futureCats.then((value) {
        _categories = null;
        _categories = value;
        setState(() {});
      });
    }
    
    _sampleRecurringOptions[0] = "None";
    _sampleRecurringOptions[1] = "Daily";
    _sampleRecurringOptions[2] = "Weekly";
    _sampleRecurringOptions[3] = "Fortnightly";
    _sampleRecurringOptions[4] = "Monthly";
    _sampleRecurringOptions[5] = "Quarterly";
    _sampleRecurringOptions[6] = "Yearly"; // these will be difficult to fetch from server as they are coded into the site's rather than fetched


    return PlatformScaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        title: Text(
          "Submit Receipt",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),

      body: ListView(
        children: <Widget>[
          // each CHILD has its own horizontal padding because if the listView has padding, Android's end-of-scroll animation
          // doesn't fit the screen properly and looks weird

          Container(
            padding: const EdgeInsets.fromLTRB(15, 17, 0, 0),
            child : Text(
              "Receipt Details",
              style: TextStyle(
                fontSize: 24,
                color: Colors.grey[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          ), // "Receipt Details" title

          Container(
            padding: EdgeInsets.fromLTRB(25,15,15.0,0.0),
            child: Row(
              children: <Widget> [
                Container(
                  child : Text(
                    "Date/Time",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  width: 110,
                ),

                Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  height: 32.0,
                  child: RaisedButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext builder) {
                            return Container(
                              height: MediaQuery.of(context).copyWith().size.height / 3,
                              child: CupertinoDatePicker(
                                initialDateTime: transaction.date.isAfter(DateTime.now())
                                  ? DateTime.now()
                                  : transaction.date,
                                onDateTimeChanged: (DateTime newDate) {
                                  setState(() => {
                                    newDate.isAfter(DateTime.now())
                                        ? transaction.date = DateTime.now()
                                        : transaction.date = newDate,
                                  });
                                },
                                use24hFormat: true,
                                maximumDate: DateTime.now(),
                              ),
                            );
                          });
                    },
                    child: Text(
                      transaction.date == null
                          ? 'None set'
                          : transaction.date.year == DateTime.now().year
                            ? '${new DateFormat.MMMd().format(transaction.date)}' + ", " + '${new DateFormat.Hm().format(transaction.date)}'
                            : '${new DateFormat.MMMd().format(transaction.date)}' + " " + transaction.date.year.toString() + ", " + '${new DateFormat.Hm().format(transaction.date)}',
                      style:
                      TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ), // Date/Time picker

          Container(
            padding: EdgeInsets.fromLTRB(25,15,15.0,0.0),
            child: Row(
              children: <Widget> [
                Container(
                  child : Text(
                    "Payee",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  width: 110,
                ),

                Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  height: 32.0,
                  child: RaisedButton(
                    onPressed: () {
//                      var popupListView = new PopupListView();
//                      var dialog = popupListView.dialog(context, optionsList, "Choose Organization");
                      var organisations = new FindOrganisations();
                      var orgDialog = organisations.dialog(context);
                      orgDialog.then((organisation) {
                        try {
                          organisation.name.length;
                          transaction.organisation = organisation;
//                          debugPrint(organisation.name);
                          setState(() {});
                        } catch(_) {
                          debugPrint("No organisation chosen.");
                        }
                      });
                    },
                    child: Text(
                      transaction.organisation.name == null
                          ? 'Find'
                          : transaction.organisation.name.length > 14
                            ? transaction.organisation.name.substring(0,12) + "..."
                            : transaction.organisation.name,
                      style:
                      TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ), // Organisation picker

          Container(
            padding: EdgeInsets.fromLTRB(25,15,15.0,0.0),
            child: Row(
              children: <Widget> [
                Container(
                  child : Text(
                    "Recurring",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  width: 110,
                ),

                Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  height: 32.0,
                  child: RaisedButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext builder) {
                            return Container(
                              height: MediaQuery.of(context).copyWith().size.height / 3,
                              child: CupertinoPicker(
                                backgroundColor: Colors.white,
                                children: _sampleRecurringOptions.map((thisOption) => Text(thisOption)).toList(),
                                onSelectedItemChanged: ((newValue) {
                                  transaction.recurring = _sampleRecurringOptions[newValue];
                                  setState(() {});
                                }),
                                itemExtent: 32,
                              ),
                            );
                          });
                    },
                    child: Text(
                      transaction.recurring == null
                          ? 'None'
                          : transaction.recurring,
                      style:
                      TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ), // Recurring picker

          Container(
            padding: EdgeInsets.fromLTRB(25,15,15.0,0.0),
            child: Row(
              children: <Widget> [
                Container(
                  child : Text(
                    "Category",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  width: 110,
                ),

                Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  height: 32.0,
//                  child: DropdownButton(
//                    value: transaction.category,
//                    items: _categories.map((thisOption) {
//                      DropdownMenuItem(child: Text(thisOption));
//                    }).toList(),
////                    items: _categories.map((thisOption) => DropdownMenuItem(child : Text(thisOption))).toList(),
//                    onChanged: ((newValue) {
//                      transaction.category = _categories[newValue];
//                      setState(() {});
//                    })
//                  ),
                  child: RaisedButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext builder) {
                            return Container(
                              height: MediaQuery.of(context).copyWith().size.height / 3,
                              child: CupertinoPicker(
                                backgroundColor: Colors.white,
                                children: _categories.map((thisOption) => Text(thisOption)).toList(),
                                onSelectedItemChanged: ((newValue) {
                                  transaction.category = _categories[newValue];
                                  setState(() {});
                                }),
                                itemExtent: 32,
                              ),
                            );
                          });
                    },
                    child: Text(
                      transaction.category == null
                          ? 'None'
                          : transaction.category,
                      style:
                      TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ), // Category picker

          Container(
            padding: EdgeInsets.fromLTRB(25,15,15.0,0.0),
            child: Row(
              children: <Widget> [
                Container(
                  child : Text(
                    "Essential",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                                    width: 95,
                ),

                Container(
                  height: 32.0,
                  child: Checkbox(
                    value: transaction.isEssential,
                    onChanged: ((value) {
                      setState(() => transaction.isEssential = value);
                    }),
                  ),
                ),
              ],
            ),
          ), // Essential

          Container(
            padding: EdgeInsets.fromLTRB(25,15,15.0,0.0),
            child: Row(
              children: <Widget> [
                Container(
                  child : Text(
                    "Amount",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  width: 110,
                ),


                Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  height: 32.0,
                  width: 100,
                  child: TextField(
                    controller: transaction.amount,
                    decoration: InputDecoration(
                        hintText: "0.00"
                    ),
                    keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
                  ),
                ),
              ],
            ),
          ), // Amount picker

          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
            child: Container(
              height: 65.0,
              child: RaisedButton(
                onPressed: () {
                  try {
                    if (transaction.amount.text == "" || transaction.organisation.name == null) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return _invalidDialog(context);
                          }
                      );
                    } else {
                      if (double.tryParse(transaction.amount.text) != null && double.tryParse(transaction.amount.text) > 0) {
                        _submitReceipt(transaction);
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return _invalidDialog(context);
                          }
                        );
                      }
                    }
                  }
                  catch (_) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return _invalidDialog(context);
                      }
                    );
                  }
                },
                child: Text("GO",
                    style:
                    TextStyle(color: Colors.white, fontSize: 22.0)),
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}