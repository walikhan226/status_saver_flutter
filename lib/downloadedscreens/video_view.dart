import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:save_status_/ui/addmanager.dart';
import 'package:save_status_/utils/video_controller.dart';

import 'package:esys_flutter_share/esys_flutter_share.dart';
import '../utils/video_controller.dart';

import 'package:video_player/video_player.dart';

class ViewPlay extends StatefulWidget {
  final String videoFile;
  ViewPlay({this.videoFile});
  @override
  _ViewPlayState createState() => _ViewPlayState();
}

class _ViewPlayState extends State<ViewPlay> {
  InterstitialAd myInterstitial;
  InterstitialAd buildInterstitialAd() {
    return InterstitialAd(
      adUnitId: AdManager.interstitialAdUnitId,
      listener: (MobileAdEvent event) {
        if (event == MobileAdEvent.failedToLoad) {
          myInterstitial..load();
        } else if (event == MobileAdEvent.closed) {
          myInterstitial = buildInterstitialAd()..load();
        }
        print(event);
      },
    );
  }

  Future<void> _initAdMob() {
    // TODO: Initialize AdMob SDK
    return FirebaseAdMob.instance.initialize(appId: AdManager.appId);
  }

  void showInterstitialAd() {
    myInterstitial..show();
  }

  @override
  void initState() {
    super.initState();
    _initAdMob();
    myInterstitial = buildInterstitialAd()..load();
  }

  @override
  void dispose() {
    super.dispose();
    myInterstitial?.dispose();
  }

  Future<void> sharevideo() async {
    try {
      final ByteData bytes = await rootBundle.load(widget.videoFile);

      await Share.file(
          'video', 'esys.mp4', bytes.buffer.asUint8List(), 'video/MP4',
          text: '');
    } catch (e) {
      print('error: $e');
    }
  }

  void _onLoading(bool t, String str) {
    if (t) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return SimpleDialog(
              children: <Widget>[
                Center(
                  child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: CircularProgressIndicator()),
                ),
              ],
            );
          });
    } else {
      Navigator.of(context).pop();
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SimpleDialog(
                children: <Widget>[
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(15.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            "Great, Saved in Gallary",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10.0),
                          ),
                          Text(str,
                              style: TextStyle(
                                fontSize: 16.0,
                              )),
                          Padding(
                            padding: EdgeInsets.all(10.0),
                          ),
                          Text("FileManager > Downloaded Status",
                              style: TextStyle(
                                  fontSize: 16.0, color: Color(0xFF096157))),
                          Padding(
                            padding: EdgeInsets.all(10.0),
                          ),
                          MaterialButton(
                            child: Text("Close"),
                            color: Color(0xFF096157),
                            textColor: Colors.white,
                            onPressed: () => Navigator.of(context).pop(),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          color: Colors.indigo,
          icon: Icon(
            Icons.close,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),

        actions: [
          IconButton(
            color: Colors.indigo,
            icon: Icon(
              Icons.delete,
              color: Colors.white,
            ),
            onPressed: () async {
              try {
                var file = File(widget.videoFile);

                if (await file.exists()) {
                  await file.delete().then((value) {
                    Navigator.pop(context);

                    setState(() {});
                  });
                }
              } catch (e) {
                print(e);
              }
            },
          ),
          IconButton(
            color: Colors.indigo,
            icon: Icon(
              Icons.share,
              color: Colors.white,
            ),
            onPressed: () {
              sharevideo();
            },
          ),
        ],
        // title: Container(
        //   padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
        //   child: FlatButton.icon(
        //     color: Colors.indigo,
        //     textColor: Colors.white,
        //     icon: Icon(Icons.file_download),
        //     padding: EdgeInsets.all(10.0),
        //     label: Text(
        //       'Download',
        //       style: TextStyle(fontSize: 16.0),
        //     ), //`Text` to display
        //     onPressed: () async {
        //       final folderName = "SaveStatus";
        //       final path = Directory("storage/emulated/0/$folderName");
        //       if ((await path.exists())) {
        //         try {
        //           showInterstitialAd();
        //         } catch (e) {}

        //         File file = File(widget.videoFile);
        //         String curDate = DateTime.now().toString();

        //         File newImage = await file
        //             .copy('storage/emulated/0/SaveStatus/vid$curDate.MP4')
        //             .then((value) {
        //           Fluttertoast.showToast(
        //               msg: "Video has been saved to local storage",
        //               toastLength: Toast.LENGTH_SHORT,
        //               gravity: ToastGravity.CENTER,
        //               timeInSecForIosWeb: 1,
        //               backgroundColor: Colors.white,
        //               textColor: Colors.black,
        //               fontSize: 16.0);
        //         });

        //         print(newImage);
        //       } else {
        //         try {
        //           showInterstitialAd();
        //         } catch (e) {}
        //         path.create();
        //         File file = File(widget.videoFile);
        //         String curDate = DateTime.now().toString();

        //         File newImage = await file
        //             .copy('storage/emulated/0/SaveStatus/vid$curDate.MP4')
        //             .then((value) {
        //           Fluttertoast.showToast(
        //               msg: "Video has been saved to local storage",
        //               toastLength: Toast.LENGTH_SHORT,
        //               gravity: ToastGravity.CENTER,
        //               timeInSecForIosWeb: 1,
        //               backgroundColor: Colors.white,
        //               textColor: Colors.black,
        //               fontSize: 16.0);
        //         });
        //         print(newImage);
        //       }
        //     },
        //   ),
        // ),
      ),
      body: Container(
        child: StatusVideo(
          videoPlayerController:
              VideoPlayerController.file(File(widget.videoFile)),
          looping: true,
          videoSrc: widget.videoFile,
        ),
      ),
    );
  }
}
