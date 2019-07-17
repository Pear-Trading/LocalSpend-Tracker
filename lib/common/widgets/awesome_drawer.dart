import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class AwesomeDrawer {

  Widget getDrawer(BuildContext context) {
  return new Container(
    width: 250,
    color: Colors.white,
//  padding: EdgeInsets.fromLTRB(32, 25, 32, 0),
  child: ListView(
  children: <Widget> [

  Container(
  padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
  child :
  FlatButton(onPressed: () => Navigator.of(context).pushReplacementNamed("/StatsPage"),
    child:
  Text("yeehaw",
  textAlign: Platform.isIOS ? TextAlign.right : TextAlign.left,
  style: new TextStyle(
  fontSize: 32.0,
  color: Colors.black,
  ),
  ),
  ),
  ),

  Container(
  padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
  child :
  FlatButton(onPressed: () => Navigator.of(context).pushReplacementNamed("/MorePage"), child:
  Text("clickity clack",
    textAlign: Platform.isIOS ? TextAlign.right : TextAlign.left,
    style: new TextStyle(
  fontSize: 32.0,
  color: Colors.black,
  ),
  ),
  ),
  ),
  Container(
  padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
  child :
  FlatButton(onPressed: () => debugPrint("pressed"), child:
  Text("scoot scoot",
  style: new TextStyle(
  fontSize: 32.0,
  color: Colors.black,
  ),
  ),
  ),
  ),

  Container(
  padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
  child :
  FlatButton(onPressed: () => debugPrint("pressed"), child:
  Text("reeeeeeeeee",
  style: new TextStyle(
  fontSize: 32.0,
  color: Colors.black,
  ),
  ),
  ),
  ),
  ]
  ),
  );
}
}