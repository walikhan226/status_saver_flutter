import 'dart:io';
import 'dart:typed_data';
import 'dart:async';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';

import 'package:path/path.dart' as path;

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

  Future<void> _initAdMob() {
    // TODO: Initialize AdMob SDK
    return FirebaseAdMob.instance.initialize(appId: AdManager.appId);
  }

  loadadd() async {
    try {
      myInterstitial = buildInterstitialAd()..load();
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _initAdMob();
    this.loadadd();
  }

  @override
  void dispose() {
    super.dispose();
    myInterstitial?.dispose();
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

  _onLoading(bool t, String str) {
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
      Navigator.pop(context);
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

  Future<File> moveFile(File sourceFile, String newPath) async {
    try {
      /// prefer using rename as it is probably faster
      /// if same directory path
      ///
      return await sourceFile.rename(newPath).then((value) {
        print("saved");
      });
    } catch (e) {
      /// if rename fails, copy the source file
      final newFile = await sourceFile.copy(newPath);
      return newFile;
    }
  }

  @override
  Widget build(BuildContext context) {
    //The list of FabMiniMenuItems that we are going to use
    // var _fabMiniMenuItemList = [
    //   new FabMiniMenuItem.withText(
    //       new Icon(Icons.sd_storage), Color(0xFF096157), 4.0, "Button menu",
    //       () async {
    //     final folderName = "SaveStatus";
    //     final path = Directory("storage/emulated/0/$folderName");
    //     if ((await path.exists())) {
    //       try {
    //         showInterstitialAd();
    //       } catch (e) {}
    //       File file = File(widget.imgPath);
    //       String curDate = DateTime.now().toString();
    //       File newImage = await file
    //           .copy('storage/emulated/0/SaveStatus/pic$curDate.jpg')
    //           .then((value) {
    //         Fluttertoast.showToast(
    //             msg: "Image has been saved to local storage",
    //             toastLength: Toast.LENGTH_SHORT,
    //             gravity: ToastGravity.CENTER,
    //             timeInSecForIosWeb: 1,
    //             backgroundColor: Colors.white,
    //             textColor: Colors.black,
    //             fontSize: 16.0);
    //       });
    //       print(newImage);
    //     } else {
    //       try {
    //         showInterstitialAd();
    //       } catch (e) {}
    //       path.create();
    //       File file = File(widget.imgPath);
    //       String curDate = DateTime.now().toString();
    //       File newImage = await file
    //           .copy('storage/emulated/0/SaveStatus/pic$curDate.jpg')
    //           .then((value) {
    //         Fluttertoast.showToast(
    //             msg: "Image has been saved to local storage",
    //             toastLength: Toast.LENGTH_SHORT,
    //             gravity: ToastGravity.CENTER,
    //             timeInSecForIosWeb: 1,
    //             backgroundColor: Colors.white,
    //             textColor: Colors.black,
    //             fontSize: 16.0);
    //       });
    //       print(newImage);
    //     }
    //   }, "Save", Colors.black, Colors.white, true),
    //   new FabMiniMenuItem.withText(
    //       new Icon(Icons.share), Color(0xFF096157), 4.0, "Button menu", () async {
    //     try {
    //       _shareImage();
    //     } catch (e) {}
    //   }, "Share", Colors.black, Colors.white, true),
    // ]
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
