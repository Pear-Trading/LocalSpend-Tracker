import 'package:flutter/material.dart';

final TextEditingController _feedbackController = TextEditingController();

void feedback(BuildContext context) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text("Feedback"),
        content: Column(
          children: <Widget>[
            Text("We would love to hear your thoughts."),
            Text("\nThis section needs to be fixed."),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              width: 200,
              height: 70,
              child: new TextField(
                controller: _feedbackController,
                decoration: InputDecoration(
                  hintText: 'Enter your feedback here',
                ),
                //                    obscureText: true,
                autocorrect: true,
                maxLines: 20,
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.bold,
                ),
                onSubmitted: (_) {
                  submit(_feedbackController.text);
                },
              ),
            ),
            new Container(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: new FlatButton(
                child: new Text("Submit"),
                onPressed: () {
                  submit(_feedbackController.text);
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

void submit(String feedback) {
  debugPrint(feedback);
}
