import 'package:flutter/material.dart';

class DropDownMenu extends StatefulWidget {

  final List<DropdownMenuItem> items;
  final Function onChanged;
  final String value;
  
  DropDownMenu({
    this.items,
    this.onChanged,
    this.value,
  });

  @override
  _DropDownMenuState createState() => _DropDownMenuState(items: this.items, onNewValue: this.onChanged, value: this.value);
}

class _DropDownMenuState extends State<DropDownMenu> {

  final List<DropdownMenuItem> items;
  final Function onNewValue;
  final String value;

  _DropDownMenuState({
    this.items,
    this.onNewValue,
    this.value
  });

  @override
  Widget build(BuildContext context) {
    return new DropdownButton(value: this.value, items: this.items, onChanged: (newValue) => onNewValue(newValue),);
  }
}