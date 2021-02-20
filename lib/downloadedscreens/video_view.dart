import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:save_status_/ui/addmanager.dart';

import 'package:save_status_/utils/video_controller.dart';

import 'package:share/share.dart';
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
  @override
  void dispose() {
    super.dispose();
    myInterstitial?.dispose();
  }

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

  void showInterstitialAd() {
    myInterstitial..show();
  }

  @override
  void initState() {
    super.initState();
    myInterstitial = buildInterstitialAd()..load();
  }

  Future<void> sharevideo() async {
    try {
      Share.shareFiles([widget.videoFile], text: 'video');
    } catch (e) {
      print('error: $e');
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

              try {
                showInterstitialAd();
              } catch (e) {
                print(e.toString());
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

              try {
                showInterstitialAd();
              } catch (e) {}
            },
          ),
        ],
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
