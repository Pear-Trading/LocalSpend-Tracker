import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_spend/common/apifunctions/submit_receipt_api.dart';
import 'package:local_spend/common/functions/show_dialog_single_button.dart';
import 'package:local_spend/common/platform/platform_scaffold.dart';
import 'package:local_spend/common/widgets/basic_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:local_spend/pages/settings.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:local_spend/common/apifunctions/find_organisations.dart';
import 'package:local_spend/common/widgets/popupListView.dart';
import 'package:local_spend/common/widgets/labeled_checkbox.dart';

const URL = "https://flutter.io/";
const demonstration = false;

class ReceiptPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ReceiptPageState();
  }
}

class ReceiptPageState extends State<ReceiptPage> {
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _essentialController = TextEditingController();
  final TextEditingController _recurringController = TextEditingController(text: "None");
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _orgController = TextEditingController();
  final OrganizationController _organizationController = OrganizationController();

  FocusNode focusNode;  // added so focus can move automatically

  DateTime date;

  Future launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: true, forceWebView: true);
    } else {
      showDialogSingleButton(
          context,
          "Unable to reach your website.",
          "Currently unable to reach the website $URL. Please try again at a later time.",
          "OK");
    }
  }

  @override
  void initState() {
    super.initState();
    _saveCurrentRoute("/ReceiptPageState");

    focusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();

    focusNode.dispose(); //disposes focus node when form disposed
  }

  _saveCurrentRoute(String lastRoute) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('LastPageRoute', lastRoute);
  }

  // this file is getting really messy sorry everyone

  void submitReceipt(String amount, String time, Organisation organisation) async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    if (amount == "" || time == "" || organisation == null) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Invalid data"),
            content: new Text(
                "We couldn't process your request because one or more required fields are missing."),
            actions: <Widget>[
              new FlatButton(
                child: new Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
    else {
      if (demonstration) {
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: new Text("Success"),
              content: new Text("Receipt successfully submitted."),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                new FlatButton(
                  child: new Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacementNamed('/HomePage');
                  },
                ),
              ],
            );
          },
        ).then((_) {});
      }

      else {
        Receipt receipt = new Receipt();

        // setting up 'receipt'
        receipt.amount = amount;
        receipt.time = formatDate(time);
//      debugPrint(organisation.name + ", " + organisation.streetName + ", " + organisation.town + ", " + organisation.postcode);
        receipt.organisationName = organisation.name;
        receipt.street = organisation.streetName;
        receipt.town = organisation.town;
        receipt.postcode = organisation.postcode;

//      receipt.essential = convertBoolToString(toConvert)

//      TODO: Categories

//      receipt.category = category;
//      receipt.etc = etc;

        submitReceiptAPI(context, receipt);
        Navigator.of(context).pushReplacementNamed('/HomePage');
      }
    }
  }

  String convertBoolToString(bool toConvert) {
    if (toConvert)
    {
      return "true";
    }

    return "false";
  }

  List<String> getOptions() {
    var options = new List<String>(7);
    options[0] = "None";
    options[1] = "Daily";
    options[2] = "Weekly";
    options[3] = "Fortnightly";
    options[4] = "Monthly";
    options[5] = "Quarterly";
    options[6] = "Yearly";

    return options;
  }

  String formatDate(String date) {
//    return "";
    // should be in format:
    // yyyy-MM-ddThh:mm:00.000+01:00
    // eg 2019-07-05T10:24:00.000+01.00 (real life example, works)

    // current format = "dd/MM/yyyy 'at' hh:mm"
    //                   0123456789ABCDEFGHIJK

    var components = new List(5);

    components[0] = (date.substring(0,2));    // dd
    components[1] = (date.substring(3,5));    // MM
    components[2] = (date.substring(6,10));   // yyyy
    components[3] = (date.substring(14,16));  // hh
    components[4] = (date.substring(17,19));  // mm

    //print(components);

    return (components[2] + "-" + components[1] + "-" + components[0]
        + "T" + components[3] + ":" + components[4] + ":00.000+01:00");

    // Yes, there is probably a function to convert dates, but I didn't
    // know that before writing this and it's done now so I'm keeping it.
  }

  Organisation listOrganisations(List<Organisation> organisations, context) {
    if (organisations.length == 0) {
      showDialogSingleButton(
          context,
          "No matching organizations",
          "We were unable to find any organizations matching this text.",
          "OK"
      );
      return null;
    }
    var optionsList = new List<String>();

    for (var i = 0; i < organisations.length; i++) {
      optionsList.add(organisations[i].name);
    }

//    var popupListView = new PopupListView(context, optionsList, "Choose Organization");

    var popupListView = new PopupListView();
    var dialog = popupListView.dialog(context, optionsList, "Choose Organization");

//    dialog.then((value) => debugPrint(value));


    dialog.then((value) {
      _orgController.text = value;
      _organizationController.organisation = organisations.where((thisOrg) => thisOrg.name == value).elementAt(0);
      // this may not work when two organisations have the same name,
      // then again the popupListView can't display two of the same names properly either
    });
    //can't return value as it is <future> and thus would block
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (Navigator.canPop(context)) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/LoginPage', (Route<dynamic> route) => false);
        } else {
          Navigator.of(context).pushReplacementNamed('/LoginPage');
        }
      },
      child: PlatformScaffold(

        appBar: AppBar(
          backgroundColor: Colors.blue[400],
          title: Text(
            "Submit Receipt",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
//          leading: BackButton(),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
        ),

        body: Container(
          padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(0.0,25,0.0,0.0),
                child : Text(
                  "Time of Transaction",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DateTimePickerFormField(
                inputType: InputType.both,
                format: DateFormat("dd/MM/yyyy 'at' hh:mm"),
                editable: true,
                controller: _timeController,
                decoration: InputDecoration(
                    labelText: 'Date/Time of Transaction', hasFloatingPlaceholder: false),
                onChanged: (dt) => setState(() => date = dt),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0.0,25,0.0,0.0),
                child: Text(
                  "Amount",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                child: TextField(
                  controller: _amountController,
                  decoration: InputDecoration(
                    hintText: 'Value in £',
                  ),
//                    obscureText: true,
                  autocorrect: false,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.bold,
                  ),
                  onSubmitted: (_) {
                    FocusScope.of(context).requestFocus(focusNode);
//                      submitReceipt(_amountController.text, _timeController.text);
                  },
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(0.0,25,0.0,0.0),

                child : Container (
                  height: 22, // this should be the same height as text

                  child : ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[

                      Container(
                        child: Text(
                          "Organization Name",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      Container(
                        child : Padding(
                          padding: EdgeInsets.fromLTRB(5,0,0,4),  // sorry about hardcoded constraints
                            child: FlatButton(
                              onPressed: () {
                                if (_orgController.text != "") {
                                  var organisations = findOrganisations(
                                      _orgController.text); // returns Future<List<Organisation>>

                                  var choice = organisations.then((data) =>
                                      listOrganisations(data, context));

                                  choice.then((value) => _orgController.text = value.name);
                                  choice.then((value) => _organizationController.organisation = value);

                                } else {
                                  // no data entered

                                  showDialogSingleButton(
                                      context,
                                      "No data",
                                      "We were unable to service your request because no data was entered.",
                                      "OK"
                                  );
                                }
                              },
                                child: Text("Find",
                                  style: TextStyle(color: Colors.blue, fontSize: 18.0)
                                ),
                            ),
                        ),
                      )

                    ],
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                child: TextField(
                  controller: _orgController,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    hintText: 'Eg. Pear Trading',
                  ),
//                    obscureText: true,
                  autocorrect: true,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.bold,
                  ),
                  onSubmitted: (_) {
                    submitReceipt(_amountController.text,
                        _timeController.text, _organizationController.organisation);
                    // TODO: make sure organisation is valid
                    // TODO: Add 'find organisation' button which displays a dialog to, well, find the organisation's address or manual entry
                  },
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(0.0,25,0.0,0.0),

                child : Container (
                  height: 18,

                  child : ListView(
                    scrollDirection: Axis.horizontal,

                    children: <Widget>[
                      Container(
                        child: Text(
                          "Essential",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      Container(
                        child : Padding(
                          padding: EdgeInsets.fromLTRB(20.0, 0.0, 0, 0),

                          child: Checkbox(value:
                          _essentialController.text.toLowerCase() == 'true',
                              onChanged: (bool newValue) {
                            setState(() {
                              _essentialController.text =
                                  convertBoolToString(newValue);
                            });
                          }),
                        ),
                      ),

                    ],
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(0.0,18,0.0,0.0),

                child : Container (
                  height: 35,
//                  width: 400,

                  child : ListView(
                    scrollDirection: Axis.horizontal,

                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 7, 0, 8),
                        child: Text(
                          "Recurring",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.fromLTRB(29, 0, 0, 0),
                        child: DropdownButton<String>(
                          value: _recurringController.text,
                          onChanged: (String newValue) {
                            setState(() {
                              _recurringController.text = newValue;
                            });
                          },
                          items: getOptions().map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          })
                              .toList(),
                        )
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 0.0),
                child: Container(
                  height: 65.0,
                  child: RaisedButton(
                    onPressed: () {
                      submitReceipt(_amountController.text, _timeController.text, _organizationController.organisation);
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
        ),
      ),
    );
  }
}
