import 'package:flutter/material.dart';
import 'package:local_spend/common/widgets/custom_checkbox.dart';

class LabeledCheckboxWithIcon extends StatelessWidget {
  const LabeledCheckboxWithIcon({
    this.label,
    this.textStyle,
    this.icon,
    this.iconSize,
    this.iconColor,
    this.padding,
    this.value,
    this.onChanged,
  });

  final String label;
  final TextStyle textStyle;
  final IconData icon;
  final double iconSize;
  final Color iconColor;
  final EdgeInsets padding;
  final bool value;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Padding(
        padding: padding,
        child: Row(
//          crossAxisAlignment: CrossAxisAlignment.center, //doesn't do anything

          children: <Widget>[
            Container(
              padding: EdgeInsets.all(0),
              width: iconSize,
              child: Icon(
                icon,
                //                size: iconSize,
                color: iconColor,
              ),
            ),
            Expanded(
                child: Text(
              label,
              style: textStyle,
              textAlign: TextAlign.center,
            )),
            CustomCheckbox(
              //custom checkbox removes padding so the form looks nice

              value: value,
              useTapTarget: false,
              onChanged: (bool newValue) {
                onChanged(newValue);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class LabeledCheckbox extends StatelessWidget {
  const LabeledCheckbox({
    this.label,
    this.textStyle,
    this.padding,
    this.value,
    this.onChanged,
  });

  final String label;
  final TextStyle textStyle;
  final EdgeInsets padding;
  final bool value;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Expanded(child: Text(label, style: textStyle)),
            CustomCheckbox(
              //custom checkbox removes padding so the form looks nice

              value: value,
              useTapTarget: false,
              onChanged: (bool newValue) {
                onChanged(newValue);
              },
            ),
          ],
        ),
      ),
    );
  }
}

/*
//USAGE:

bool _isSelected = false;

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Center(
      child: LabeledCheckbox(
        label: 'Label Text Here',
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        value: _isSelected,

        onChanged: (bool newValue) {
          setState(() {
            _isSelected = newValue;
          });
        },
      ),
    ),
  );
}
*/
