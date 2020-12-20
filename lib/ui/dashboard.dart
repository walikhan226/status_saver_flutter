import 'package:test123/ui/imageScreen.dart';
import 'package:test123/ui/videoScreen.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  @override
  DashboardState createState() => new DashboardState();
}

class DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: TabBarView(
        children: [
          ImageScreen(),
          VideoScreen(),
        ],
      ),
    );
  }
}
