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
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

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
  final TextEditingController _recurringController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _orgController = TextEditingController();

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

  void submitReceipt(String amount, String time, String orgName) async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    if (demonstration)
    {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Success"),
            content: new Text("Recepit successfully submitted."),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      ).then((_) {
      Navigator.of(context).pushNamed('/HomePage');
    });
    }
    else {
      Receipt receipt = new Receipt();

      // setting up 'receipt'
      receipt.amount = amount;
      receipt.time = formatDate(time);
      receipt.organisationName = orgName;

//      receipt.essential = convertBoolToString(toConvert)

      //TODO: initialise receipt with correct values from form

//      receipt.category = category;
//      receipt.etc = etc;

      submitReceiptAPI(context, receipt);
    }
  }

  String convertBoolToString(bool toConvert) {
    if (toConvert)
    {
      return "true";
    }

    return "false";
  }

  String formatDate(String date) {
//    return "";
    // should be in format:
    // yyyy-MM-ddThh:mm:00.000+01:00
    // eg 2019-07-05T10:24:00.000+01.00 (real life example, works)

    // current format = "dd/MM/yyyy 'at' hh:mm"

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

  @override
  Widget build(BuildContext context) {
    var drawer = Drawer();
    return WillPopScope(
      onWillPop: () {
        if (Navigator.canPop(context)) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/HomePage', (Route<dynamic> route) => false);
        } else {
          Navigator.of(context).pushReplacementNamed('/HomePage');
        }
      },
      child: PlatformScaffold(
        drawer: BasicDrawer(),
        appBar: AppBar(
          title: Text(
            "Submit Receipt",
            style: TextStyle(
              fontSize: 30.0,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: Container(
          child: Padding(
            padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
            child: ListView(
              children: <Widget>[
//                Container(
//                    alignment: Alignment.topCenter,
//                    child: Padding(
//                      padding: EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 15.0),
//                      child: Text(
//                        "Required fields are in bold",
//                        style: TextStyle(fontSize: 20.0, color: Colors.black),
//                      ),
//                    )),
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
                            padding: EdgeInsets.fromLTRB(5,0,0,4),
                              child: FlatButton(
                                onPressed: () {
                                  debugPrint("TODO: 'find organisation' dialog");
                                  // Writing this before I forget tomorrow morning:
                                  // Steps to fetch list of organisations with similar name:
                                  // 1) record network activity (requests) of FoodLoop-Web webapp on Firefox
                                  // 2) look at JSON files returned by server when 'organisation name' field's text updates/changes
                                  // 3) look at requests sent to server when web textfield updates and send those from app
                                  // 4) I'm tired
                                },
                                  child: Text("Find",
                                    style:
                                    TextStyle(color: Colors.blue, fontSize: 18.0)),
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
                          _timeController.text, _orgController.text);
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
                            "Essential Purchase",
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
                  padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
                  child: Container(
                    height: 65.0,
                    child: RaisedButton(
                      onPressed: () {
                        submitReceipt(_amountController.text, _timeController.text, _orgController.text);
                      },
                      child: Text("SUBMIT",
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
      ),
    );
  }
}
