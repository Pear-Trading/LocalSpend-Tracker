import 'package:flutter/material.dart';

class PopupListView {
  List<String> options = new List<String>();
  var context;
  String listTitle;
  List<SimpleDialogOption> simpleDialogOptions = new List<SimpleDialogOption>();
  String result;

  PopupListView(context, List<String> options, String title) {
    this.context = context;
    this.options = options;
    this.listTitle = title;
  }


  List<SimpleDialogOption> getDialogOptions() {
    var dialogOptionsList = new List<SimpleDialogOption>();

    for (var i = 0; i < options.length; i++) {
      dialogOptionsList.add(
        new SimpleDialogOption(
          child: Text(options[i]),
          onPressed: () {
            Navigator.of(this.context).pop();
//            print("Chosen organisation is " + options[i]);
            optionChosen(options[i]);
          },
        ),
      );
    }

    return dialogOptionsList;
  }



  Widget dialog() {
    return new SimpleDialog(
      title: Text(listTitle),
      children : getDialogOptions(),
    );
  }

  void optionChosen(String option) {
    // now pass `option` to
  }
}




