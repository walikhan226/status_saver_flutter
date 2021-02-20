import 'dart:io';

import 'dart:async';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:save_status_/ui/addmanager.dart';

import 'package:share/share.dart';

class ViewPhotos extends StatefulWidget {
  final String imgPath;
  ViewPhotos(this.imgPath);

  @override
  _ViewPhotosState createState() => _ViewPhotosState();
}

class _ViewPhotosState extends State<ViewPhotos> {
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
      /// prefer using rename as it is probably faster
      /// if same directory path
      ///
      return await sourceFile.rename(newPath).then((value) {
        print("saved");
        return;
      });
    } catch (e) {
      /// if rename fails, copy the source file
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
              Icons.download_rounded,
              color: Colors.white,
            ),
            onPressed: () async {
              final folderName = "SaveStatus";
              final path = Directory("storage/emulated/0/$folderName");
              if ((await path.exists())) {
                try {} catch (e) {}
                File file = File(widget.imgPath);
                String curDate = DateTime.now().toString();
                curDate = curDate.replaceAll(' ', '');
                print(curDate);
                File newImage = await file
                    .copy('storage/emulated/0/SaveStatus/pic$curDate.jpg')
                    .then((value) {
                  Fluttertoast.showToast(
                      msg: "Image has been saved to local storage",
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
                path.create();
                File file = File(widget.imgPath);
                String curDate = DateTime.now().toString();
                curDate = curDate.replaceAll(' ', '');
                File newImage = await file
                    .copy('storage/emulated/0/SaveStatus/pic$curDate.jpg')
                    .then((value) {
                  Fluttertoast.showToast(
                      msg: "Image has been saved to local storage",
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
            onPressed: () {
              try {
                Share.shareFiles([widget.imgPath], text: 'picture');
              } catch (e) {}

              try {
                showInterstitialAd();
              } catch (e) {}
            },
          ),
        ],
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
