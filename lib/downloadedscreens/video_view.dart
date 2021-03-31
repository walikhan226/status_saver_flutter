import 'dart:io';

import 'package:facebook_audience_network/ad/ad_interstitial.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  bool _isInterstitialAdLoaded = false;
  void _loadInterstitialAd() {
    FacebookInterstitialAd.loadInterstitialAd(
      placementId:
          "724225414947921_724310951606034", //"IMG_16_9_APP_INSTALL#2312433698835503_2650502525028617" YOUR_PLACEMENT_ID
      listener: (result, value) {
        print(">> FAN > Interstitial Ad: $result --> $value");
        if (result == InterstitialAdResult.LOADED) {
          _isInterstitialAdLoaded = true;
        }

        /// Once an Interstitial Ad has been dismissed and becomes invalidated,
        /// load a fresh Ad by calling this function.
        if (result == InterstitialAdResult.DISMISSED &&
            value["invalidated"] == true) {
          _isInterstitialAdLoaded = false;
          _loadInterstitialAd();
        }
      },
    ).then((b) {
      _showInterstitialAd();
      return;
    });
  }

  _showInterstitialAd() {
    if (_isInterstitialAdLoaded == true)
      FacebookInterstitialAd.showInterstitialAd();
    else {
      FacebookInterstitialAd.loadInterstitialAd(
          placementId: "724225414947921_724310951606034");
    }
    print("Interstial Ad not yet loaded!");
  }

  @override
  void dispose() {
    super.dispose();
  }

//6b6c2b4fd054432495920692cd535138

  @override
  void initState() {
    _loadInterstitialAd();
    super.initState();
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
                _showInterstitialAd();
              } catch (e) {}
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
