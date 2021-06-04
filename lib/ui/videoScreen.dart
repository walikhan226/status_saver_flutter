import 'package:save_status_/downloadedscreens/video_view.dart';
import 'package:save_status_/utils/video_play.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:thumbnails/thumbnails.dart';

import 'package:path_provider/path_provider.dart';

class VideoScreen extends StatefulWidget {
  final String path;
  final String state;
  VideoScreen({@required this.path, @required this.state});
  @override
  VideoScreenState createState() => new VideoScreenState();
}

class VideoScreenState extends State<VideoScreen> {
  Directory _videoDir;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _videoDir = Directory(widget.path);
    if (!Directory("${_videoDir.path}").existsSync()) {
      return Container(
        padding: EdgeInsets.only(bottom: 60.0),
        child: Center(
          child: Text(
            "Install WhatsApp\nYour Friend's Status will be available here.",
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      );
    } else {
      return VideoGrid(
        directory: _videoDir,
        state: widget.state,
      );
    }
  }
}

class VideoGrid extends StatefulWidget {
  final Directory directory;
  final String state;
  const VideoGrid({this.directory, this.state});

  @override
  _VideoGridState createState() => _VideoGridState();
}

class _VideoGridState extends State<VideoGrid> {
  List<Widget> thumpnail = [];
  Future<String> getImage(videoPathUrl) async {
    print(videoPathUrl);
    var appDocDir = await getApplicationDocumentsDirectory();
    final folderPath = appDocDir.path;
    String thumb = await Thumbnails.getThumbnail(
        thumbnailFolder: folderPath,
        videoFile: videoPathUrl,
        imageType: ThumbFormat.PNG,
        quality: 30);

    return thumb;
  }

  var ischecked = false;
  getdata() async {
    thumpnail = [];
    for (int i = 0; i < videoList.length; i++) {
      var appDocDir = await getApplicationDocumentsDirectory();
      final folderPath = appDocDir.path;
      String thumb = await Thumbnails.getThumbnail(
          thumbnailFolder: folderPath,
          videoFile: videoList[i],
          imageType: ThumbFormat.PNG,
          quality: 30);

      thumpnail.add(Image.file(File(thumb)));
    }
    ischecked = true;
    setState(() {});
  }

  var videoList;
  @override
  void initState() {
    super.initState();
    videoList = widget.directory
        .listSync()
        .map((item) => item.path)
        .where((item) => item.endsWith(".MP4") || item.endsWith(".mp4"))
        .toList();

    for (int i = 0; i < videoList.length; i++) {
      thumpnail.add(Image.asset("assets/images/video_loader.gif"));
    }

    setState(() {});
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 60.0),
      child: GridView.builder(
        itemCount: videoList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1, childAspectRatio: 8.0 / 8.0),
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.all(10.0),
            child: InkWell(
              onTap: () async {
                if (widget.state == 'main') {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new PlayStatus(
                              videoFile: videoList[index],
                            )),
                  );
                }

                if (widget.state == 'download') {
                  var val = await Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new ViewPlay(
                              videoFile: videoList[index],
                            )),
                  ).then((value) {
                    setState(() {});
                  });
                }
              },
              child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      stops: [0.1, 0.3, 0.5, 0.7, 0.9],
                      colors: [
                        Color(0xffb7d8cf),
                        Color(0xffb7d8cf),
                        Color(0xffb7d8cf),
                        Color(0xffb7d8cf),
                        Color(0xffb7d8cf),
                      ],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Column(children: <Widget>[
                    Hero(
                      tag: videoList[index],
                      child: Container(
                        height: 280.0,
                        child: ischecked
                            ? thumpnail[index]
                            : Image.asset("assets/images/video_loader.gif"),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: RaisedButton(
                        child: Text("Play Video"),
                        color: Color(0xFF096157),
                        textColor: Colors.white,
                        onPressed: () async {
                          if (widget.state == 'main') {
                            Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => new PlayStatus(
                                        videoFile: videoList[index],
                                      )),
                            );
                          }

                          if (widget.state == 'download') {
                            var val = await Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => new ViewPlay(
                                        videoFile: videoList[index],
                                      )),
                            ).then((value) {
                              setState(() {});
                            });
                          }
                        },
                      ),
                    ),
                  ])),
            ),
          );
        },
      ),
    );
  }
}
