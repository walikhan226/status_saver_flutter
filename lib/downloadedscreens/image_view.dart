import 'dart:io';
import 'dart:async';
import 'package:facebook_audience_network/ad/ad_interstitial.dart';
import 'package:flutter/material.dart';
import 'package:save_status_/ui/banneradd.dart';

import 'package:share/share.dart';

class ImageView extends StatefulWidget {
  final String imgPath;
  ImageView(this.imgPath);
  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
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

  Future<void> _shareImage() async {
    print(widget.imgPath);
    try {
      Share.shareFiles([widget.imgPath], text: 'picture');
    } catch (e) {
      print('error: $e');
    }
  }

  final LinearGradient backgroundGradient = new LinearGradient(
    colors: [
      Color(0x00000000),
      Color(0x00333333),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  Future<File> moveFile(File sourceFile, String newPath) async {
    try {
      return await sourceFile.rename(newPath).then((value) {
        print("saved");
        return;
      });
    } catch (e) {
      final newFile = await sourceFile.copy(newPath);
      return newFile;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            color: Colors.indigo,
            icon: Icon(
              Icons.delete,
              color: Colors.white,
            ),
            onPressed: () async {
              try {
                var file = File(widget.imgPath);

                if (await file.exists()) {
                  await file.delete().then((value) {
                    Navigator.pop(context);

                    //  setState(() {});
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
            onPressed: () async {
              try {
                _showInterstitialAd();
              } catch (e) {}

              _shareImage();
            },
          ),
        ],
        leading: IconButton(
          color: Colors.indigo,
          icon: Icon(
            Icons.close,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SizedBox.expand(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Hero(
                tag: widget.imgPath,
                child: Image.file(
                  File(widget.imgPath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // new FabDialer(
            //     _fabMiniMenuItemList, Color(0xFF096157), new Icon(Icons.add)),
          ],
        ),
      ),
      bottomSheet: Banneradd(),
    );
  }
}
