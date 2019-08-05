import 'package:flutter/material.dart';
import 'package:local_spend/common/platform/platform_scaffold.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';

class ReceiptPage2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ReceiptPage2State();
  }
}

class ReceiptPage2State extends State<ReceiptPage2> {
  DateTime _transactionDate = DateTime.now();

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
          ),

          Container(
            padding: EdgeInsets.fromLTRB(25,15,15.0,0.0),
            child: Row(
              children: <Widget> [
                Text(
                  "Date/Time",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Container(
                  padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                  height: 32.0,
                  child: RaisedButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext builder) {
                            return Container(
                              height: MediaQuery.of(context).copyWith().size.height / 3,
                              child: CupertinoDatePicker(
                                initialDateTime: _transactionDate.isAfter(DateTime.now())
                                  ? DateTime.now()
                                  : _transactionDate,
                                onDateTimeChanged: (DateTime newDate) {
                                  setState(() => {
                                    newDate.isAfter(DateTime.now())
                                        ? _transactionDate = DateTime.now()
                                        : _transactionDate = newDate,
                                  });
                                },
                                use24hFormat: true,
                                maximumDate: DateTime.now(),
                              ),
                            );
                          });
                    },//                      onPressed: () => showDatePicker(context: context, initialDate: _transactionDate, firstDate: null, lastDate: _transactionDate),
                    child: Text(
                      _transactionDate == null
                          ? 'None set.'
                          : _transactionDate.year == DateTime.now().year
                            ? '${new DateFormat.MMMd().format(_transactionDate)}' + ", " + '${new DateFormat.Hm().format(_transactionDate)}'
                            : '${new DateFormat.MMMd().format(_transactionDate)}' + " " + _transactionDate.year.toString() + ", " + '${new DateFormat.Hm().format(_transactionDate)}',
                      style:
                      TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),

        ],
      ),

    );
  }
}