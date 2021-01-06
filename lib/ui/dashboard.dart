import 'package:save_status_/ui/imageScreen.dart';
import 'package:save_status_/ui/videoScreen.dart';
import 'package:flutter/material.dart';
import 'viewdownloads.dart';

class Dashboard extends StatefulWidget {
  @override
  DashboardState createState() => new DashboardState();
}

class DashboardState extends State<Dashboard> {
  final path = '/storage/emulated/0/WhatsApp/Media/.Statuses';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        children: [
          ImageScreen(
            path: this.path,
            state: 'main',
          ),
          VideoScreen(
            state: 'main',
            path: this.path,
          ),
          ViewDownloadFolder(
            state: 'download',
            path: '/storage/emulated/0/SaveStatus',
          )
        ],
      ),
    );
  }
}
