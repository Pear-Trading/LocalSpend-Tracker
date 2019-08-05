import 'package:flutter/material.dart';
import 'package:local_spend/common/platform/platform_scaffold.dart';

class ReceiptPage2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ReceiptPage2State();
  }
}

class ReceiptPage2State extends State<ReceiptPage2> {
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
    );
  }
}