import 'package:flutter/material.dart';
import 'package:local_spend/common/platform/platform_scaffold.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:local_spend/common/apifunctions/find_organisations.dart';
import 'package:local_spend/common/widgets/organisations_dialog.dart';

class Transaction {
  DateTime date;
  TextEditingController amount;
  Organisation organisation;

  Transaction(
    this.date,
    this.amount,
    this.organisation,
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
  );
  
  @override
  Widget build(BuildContext context) {

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
                    },//                      onPressed: () => showDatePicker(context: context, initialDate: _transactionDate, firstDate: null, lastDate: _transactionDate),
                    child: Text(
                      transaction.date == null
                          ? 'None set.'
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
                        debugPrint(organisation.name);
                      });
                    },
                    child: Text(
                      transaction.organisation.name == null
                          ? 'Find'
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
                        hintText: "£0.00"
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
          ), // Amount picker

        ],
      ),
    );
  }
}