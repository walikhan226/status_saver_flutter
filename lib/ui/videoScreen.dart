import 'package:save_status_/downloadedscreens/video_view.dart';
import 'package:save_status_/utils/video_play.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:thumbnails/thumbnails.dart';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

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
  Future<String> _getImage(String videoPathUrl) async {
    try {
      await Future.delayed(Duration(milliseconds: 500));

      return await Thumbnails.getThumbnail(
          videoFile: videoPathUrl,
          imageType:
              ThumbFormat.PNG, //this image will store in created folderpath
          quality: 30);
    } catch (e) {
      throw (e);
    }
  }

  Future<String> getImage(videoPathUrl) async {
    print(videoPathUrl);
    var appDocDir = await getApplicationDocumentsDirectory();
    final folderPath = appDocDir.path;
    String thumb = await Thumbnails.getThumbnail(
        thumbnailFolder: folderPath,
        videoFile: videoPathUrl,
        imageType:
            ThumbFormat.PNG, //this image will store in created folderpath
        quality: 30);
    print(" Thump is " + thumb);
    return thumb;
  }

  @override
  Widget build(BuildContext context) {
    var videoList = widget.directory
        .listSync()
        .map((item) => item.path)
        .where((item) => item.endsWith(".MP4") || item.endsWith(".mp4"))
        .toList(growable: false);

    if (videoList != null) {
      if (videoList.length > 0) {
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
                        // Where the linear gradient begins and ends
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        // Add one stop for each color. Stops should increase from 0 to 1
                        stops: [0.1, 0.3, 0.5, 0.7, 0.9],
                        colors: [
                          // Colors are easy thanks to Flutter's Colors class.
                          Color(0xffb7d8cf),
                          Color(0xffb7d8cf),
                          Color(0xffb7d8cf),
                          Color(0xffb7d8cf),
                          Color(0xffb7d8cf),
                        ],
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: FutureBuilder(
                        future: getImage(videoList[index]),
                        builder: (context, AsyncSnapshot<String> snapshot) {
                          if (snapshot.hasError) {
                            print("This error " + snapshot.error);
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasData) {
                              return Column(children: <Widget>[
                                Hero(
                                  tag: videoList[index],
                                  child: Image.file(
                                    File(snapshot.data),
                                    height: 280.0,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 10.0),
                                  child: RaisedButton(
                                    child: Text("Play Video"),
                                    color: Color(0xFF096157),
                                    textColor: Colors.white,
                                    onPressed: () async {
                                      if (widget.state == 'main') {
                                        Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (context) =>
                                                  new PlayStatus(
                                                    videoFile: videoList[index],
                                                  )),
                                        );
                                      }

                                      if (widget.state == 'download') {
                                        var val = await Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (context) =>
                                                  new ViewPlay(
                                                    videoFile: videoList[index],
                                                  )),
                                        ).then((value) {
                                          setState(() {});
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ]);
                            } else {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          } else {
                            return Hero(
                              tag: videoList[index],
                              child: Container(
                                height: 280.0,
                                child: Image.asset(
                                    "assets/images/video_loader.gif"),
                              ),
                            );
                          }
                        }),
                    //new cod
                  ),
                ),
              );
            },
          ),
        );
      } else {
        return Center(
          child: Container(
            padding: EdgeInsets.only(bottom: 60.0),
            child: Text(
              "Sorry, No Videos Found.",
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        );
      }
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
