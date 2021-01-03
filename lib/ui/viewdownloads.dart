import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:path/path.dart';
import 'package:save_status_/ui/imageScreen.dart';
import 'package:save_status_/ui/videoScreen.dart';
import 'package:save_status_/ui/viewphotos.dart';
import 'package:save_status_/utils/video_play.dart';
import 'package:thumbnails/thumbnails.dart';
import 'package:flutter/material.dart';

class ViewDownloadFolder extends StatefulWidget {
  @override
  _ViewDownloadFolderState createState() => _ViewDownloadFolderState();
}

class _ViewDownloadFolderState extends State<ViewDownloadFolder> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          Card(
            color: Colors.grey[300],
            child: ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Scaffold(
                              appBar: AppBar(
                                backgroundColor: Colors.teal,
                                title: Text("Images"),
                              ),
                              body: ImageScreen(),
                            )));
              },
              leading: Text("Images"),
            ),
          ),
          Card(
            color: Colors.grey[300],
            child: ListTile(
              leading: Text("Videos"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Scaffold(
                              appBar: AppBar(
                                backgroundColor: Colors.teal,
                                title: Text("Videos"),
                              ),
                              body: VideoScreen(),
                            )));
              },
            ),
          ),
        ],
      ),
    );
  }
}
