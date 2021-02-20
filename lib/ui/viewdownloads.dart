import 'package:flutter/cupertino.dart';

import 'package:save_status_/ui/imageScreen.dart';

import 'package:save_status_/ui/videoScreen.dart';

import 'package:flutter/material.dart';

class ViewDownloadFolder extends StatefulWidget {
  String path;
  String state;
  ViewDownloadFolder({@required this.path, @required this.state});

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
            elevation: 5,
            color: Colors.white,
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 10.0),
              leading: Image.asset("assets/images/imageicon.png"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Scaffold(
                              appBar: AppBar(
                                backgroundColor: Color(0xFF096157),
                                title: Text(
                                  "Images",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              body: ImageScreen(
                                path: widget.path,
                                state: widget.state,
                              ),
                            )));
              },
              title: Text("Images"),
            ),
          ),
          Card(
            elevation: 5,
            color: Colors.white,
            child: ListTile(
              leading: Image.asset("assets/images/videoicon.png"),
              contentPadding: EdgeInsets.symmetric(vertical: 10.0),
              title: Text("Videos"),
              onTap: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Scaffold(
                              appBar: AppBar(
                                backgroundColor: Color(0xFF096157),
                                title: Text(
                                  "Videos",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              body: VideoScreen(
                                path: widget.path,
                                state: widget.state,
                              ),
                            )));
              },
            ),
          ),
        ],
      ),
    );
  }
}
