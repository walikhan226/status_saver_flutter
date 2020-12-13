import 'package:test123/ui/dashboard.dart';
import 'package:test123/ui/home.dart';
import 'package:test123/ui/mydrawer.dart';
import 'package:flutter/material.dart';

import 'package:share/share.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_html/flutter_html.dart';

void main() async {
  runApp(Start());
}

class Start extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyApp(),
    );
  }
}
