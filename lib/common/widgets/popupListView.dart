import 'package:flutter/material.dart';
import 'dart:async';

class PopupListView {
  Future<dynamic> dialog(context, List<String> options, String title) {
    return showDialog<dynamic>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(title),
          children: getDialogOptions(context, options),
        );
      },
    );
  }

  List<Widget> getDialogOptions(
      context, List<String> options /*, Function onPressed*/) {
    var dialogOptionsList = new List<SimpleDialogOption>();

    for (var i = 0; i < options.length; i++) {
      dialogOptionsList.add(
        new SimpleDialogOption(
          // print each iteration to see if any are null
          child: Text(options[i]),
          onPressed: () {
            Navigator.of(context).pop(options[i]);
          },
        ),
      );
    }

    return dialogOptionsList;
  }
}
