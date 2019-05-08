import 'package:flutter/material.dart';
import 'package:local_spend/config.dart';
import 'package:local_spend/env/dev.dart';
import 'package:local_spend/main.dart';

void main() => runApp(
    new ConfigWrapper(config: Config.fromJson(config), child: new MyApp()));
