import 'dart:io';
import 'dart:async';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:save_status_/ui/addmanager.dart';

import 'package:share/share.dart';

class ImageView extends StatefulWidget {
  final String imgPath;
  ImageView(this.imgPath);
  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
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
                showInterstitialAd();
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
              _shareImage();
              try {
                showInterstitialAd();
              } catch (e) {}
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
