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
  }

  _saveCurrentRoute(String lastRoute) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('LastPageRoute', lastRoute);
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
                Container(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 15.0),
                      child: Text(
                        "Required Fields in bold",
                        style: TextStyle(fontSize: 20.0, color: Colors.black),
                      ),
                    )),
                Text(
                  "Time of Transaction",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DateTimePickerFormField(
                  inputType: InputType.both,
                  format: DateFormat("EEEE, MMMM d, yyyy 'at' h:mma"),
                  editable: true,
                  decoration: InputDecoration(
                      labelText: 'Date/Time of Transaction', hasFloatingPlaceholder: false),
                  onChanged: (dt) => setState(() => date = dt),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 35.0, 0.0, 0.0),
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
                    obscureText: true,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
                  child: Container(
                    height: 65.0,
                    child: RaisedButton(
                      onPressed: () {
                        SystemChannels.textInput.invokeMethod('TextInput.hide');
                        submitReceiptAPI(context, _amountController.text,
                            _timeController.text);
                      },
                      child: Text("LOGIN",
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
