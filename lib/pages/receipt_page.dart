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
  final TextEditingController _recurringController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _orgController = TextEditingController();
  bool _recurringCheckbox = false;   // have mercy, this will be removed. sorry for this variable's placement...

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

  String listOrganisations(List<Organisation> organisations, context) {
    var optionsList = new List<String>();

    for (var i = 0; i < organisations.length; i++) {
      optionsList.add(organisations[i].name);
    }

    var popupListView = new PopupListView(context, optionsList, "Choose Organization");

    var dialog = popupListView.dialog();

//    print(dialog);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
    );

    print(popupListView.result);
    return popupListView.result;
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
              color: Colors.black,
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
                                var organisations = findOrganisations(_orgController.text);
                                // some tasty async stuff here yum yum
                                // and a pretty little dialog too yay (doesn't work)
                                var choice = organisations.then((data) => listOrganisations(data, context));

                                // choice is a Future<String>
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
                padding: EdgeInsets.fromLTRB(0.0,25,0.0,0.0),

                child : Container (
                  height: 27,
//                  width: 400,

                  child : ListView(
                    scrollDirection: Axis.horizontal,

                    children: <Widget>[
                      Container(
                        child: Text(
                          "Recurring",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      Container(
                        child : Padding(
                          padding: EdgeInsets.fromLTRB(15.0, 0.0, 0, 4),

                          child: Checkbox(value:
                          _essentialController.text.toLowerCase() != "none" ||
                              _essentialController.text.toLowerCase() != 'false',
                              onChanged: (bool newValue) {
                                setState(() {
                                  var options = new List<String>(7);
                                  options[0] = "Daily";
                                  options[1] = "Weekly";
                                  options[2] = "Fortnightly";
                                  options[3] = "Monthly";
                                  options[5] = "Quarterly";
                                  options[6] = "Yearly";

                                  var popupListView = new PopupListView(
                                      context, options, "Recurring...");

                                  var dialog = popupListView.dialog();

                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return dialog;
                                    },
                                  );

                                  print(popupListView.result);
//                                  _recurringController.text =
//                                      popupListView.result;
                                });
                              }),
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
                        child: Text(
                          convertBoolToString(_essentialController.text.toLowerCase() != "none" ||
                              _essentialController.text.toLowerCase() != 'false'),
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),


//                            var options = new List<String>(1);
//                            options[0] = "Weekly";
//
//                            var popupListView = new PopupListView(context, options, "Recurring...");
//
//                            var dialog = popupListView.dialog();
//
//                            showDialog(
//                              context: context,
//                              builder: (BuildContext context) {
//                                return dialog;
//                              },
//                            );
//
//                            print(popupListView.result);
//                            _recurringController.text =  popupListView.result;
//
//                                setState(() {
//                                  _recurringController.text =
//                                      convertBoolToString(newValue);


              Padding(
                padding: EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 0.0),
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
    );
  }
}
