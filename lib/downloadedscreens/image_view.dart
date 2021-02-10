import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mopub_flutter/mopub.dart';
import 'package:mopub_flutter/mopub_banner.dart';
import 'package:mopub_flutter/mopub_interstitial.dart';
import 'package:save_status_/ui/addmanager.dart';
import 'package:share/share.dart';

class ImageView extends StatefulWidget {
  final String imgPath;
  ImageView(this.imgPath);
  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
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

  Future<void> _shareImage() async {
    print(widget.imgPath);
    try {
      Share.shareFiles([widget.imgPath], text: 'picture');
      mInterstitial.show();
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
              mInterstitial.show();

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
            },
          ),
          IconButton(
            color: Colors.indigo,
            icon: Icon(
              Icons.share,
              color: Colors.white,
            ),
            onPressed: () async {
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
    );
  }
}
