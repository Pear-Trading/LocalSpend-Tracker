import 'package:flutter/material.dart';

void showDialogTwoButtons(
    BuildContext context, String title, String message, String buttonLabel1, String buttonLabel2, Function action) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text(title),
        content: new Text(message),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog

          new FlatButton(
            child: new Text(buttonLabel1),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),

          new FlatButton(
            child: new Text(buttonLabel2),
            onPressed: () {
              action(context);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
