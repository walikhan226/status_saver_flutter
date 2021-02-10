import 'package:fluttertoast/fluttertoast.dart';
import 'package:mopub_flutter/mopub.dart';
import 'package:mopub_flutter/mopub_banner.dart';
import 'package:mopub_flutter/mopub_interstitial.dart';
import 'package:save_status_/ui/addmanager.dart';
import 'package:save_status_/utils/video_controller.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:video_player/video_player.dart';

class PlayStatus extends StatefulWidget {
  String videoFile;
  PlayStatus({this.videoFile});
  @override
  _PlayStatusState createState() => new _PlayStatusState();
}

class _PlayStatusState extends State<PlayStatus> {
  MoPubBannerAd moPubBannerAd;
  MoPubInterstitialAd mInterstitial;
  @override
  void dispose() {
    super.dispose();
    mInterstitial?.dispose();
  }

  void _loadInterstitialAd() {
    mInterstitial = MoPubInterstitialAd(
      '6b6c2b4fd054432495920692cd535138',
      (result, args) {
        print('Interstitial $result');
      },
      reloadOnClosed: true,
    );
  }

  loadadd() {
    try {
      MoPub.init(AdManager.bannerid, testMode: false);
    } catch (e) {}

    try {
      MoPub.init(AdManager.interstialid, testMode: false).then((_) {
        _loadInterstitialAd();
        mInterstitial.load();
      });
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();

    loadadd();
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
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
          child: FlatButton.icon(
            color: Color(0xFF096157),
            textColor: Colors.white,
            icon: Icon(Icons.file_download),
            padding: EdgeInsets.all(10.0),
            label: Text(
              'Download',
              style: TextStyle(fontSize: 16.0),
            ), //`Text` to display
            onPressed: () async {
              final folderName = "SaveStatus";
              final path = Directory("storage/emulated/0/$folderName");
              if ((await path.exists())) {
                try {
                  mInterstitial.show();
                } catch (e) {}

                File file = File(widget.videoFile);
                String curDate = DateTime.now().toString();
                curDate = curDate.replaceAll(' ', '');
                curDate = curDate.replaceAll('.', '');
                curDate = curDate.replaceAll(':', '');
                curDate = curDate.replaceAll('-', '');
                File newImage = await file
                    .copy('storage/emulated/0/SaveStatus/vid$curDate.mp4')
                    .then((value) {
                  Fluttertoast.showToast(
                      msg: "Video has been saved to local storage",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                      fontSize: 16.0);
                  return;
                });

                print(newImage);
              } else {
                try {
                  mInterstitial.show();
                } catch (e) {}
                path.create();
                File file = File(widget.videoFile);
                String curDate = DateTime.now().toString();
                curDate = curDate.replaceAll(' ', '');
                curDate = curDate.replaceAll('.', '');
                curDate = curDate.replaceAll(':', '');
                curDate = curDate.replaceAll('-', '');
                File newImage = await file
                    .copy('storage/emulated/0/SaveStatus/vid$curDate.mp4')
                    .then((value) {
                  Fluttertoast.showToast(
                      msg: "Video has been saved to local storage",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                      fontSize: 16.0);
                  return;
                });
                print(newImage);
              }
            },
          ),
        ),
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
