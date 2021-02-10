import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mopub_flutter/mopub.dart';
import 'package:mopub_flutter/mopub_banner.dart';
import 'package:mopub_flutter/mopub_interstitial.dart';
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

  Future<void> sharevideo() async {
    try {
      Share.shareFiles([widget.videoFile], text: 'video');
      mInterstitial.show();
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

              mInterstitial.show();
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
