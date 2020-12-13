import 'dart:io';
import 'dart:typed_data';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter_fab_dialer/flutter_fab_dialer.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart' as eshare;

import 'package:path_provider/path_provider.dart';

class ViewPhotos extends StatefulWidget {
  final String imgPath;
  ViewPhotos(this.imgPath);

  @override
  _ViewPhotosState createState() => _ViewPhotosState();
}

class _ViewPhotosState extends State<ViewPhotos> {
  var filePath;
  final String imgShare = "Image.file(File(widget.imgPath),)";

  Future<void> _shareImage() async {
    try {
      final ByteData bytes = await rootBundle.load(
        "Image.file(File(widget.imgPath),)",
      );
      await eshare.Share.file(
        'esys image',
        'esys.png',
        bytes.buffer.asUint8List(),
        imgShare,
      );
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
                                  fontSize: 16.0, color: Colors.teal)),
                          Padding(
                            padding: EdgeInsets.all(10.0),
                          ),
                          MaterialButton(
                            child: Text("Close"),
                            color: Colors.teal,
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
    var _fabMiniMenuItemList = [
      new FabMiniMenuItem.withText(
          new Icon(Icons.sd_storage), Colors.teal, 4.0, "Button menu",
          () async {
        final folderName = "StatusSaver";
        final path = Directory("storage/emulated/0/$folderName");
        if ((await path.exists())) {
          File file = File(widget.imgPath);
          String curDate = DateTime.now().toString();
          File newImage =
              await file.copy('storage/emulated/0/StatusSaver/pic$curDate.jpg');
          print(newImage);
        } else {
          path.create();
          File file = File(widget.imgPath);
          String curDate = DateTime.now().toString();
          File newImage =
              await file.copy('storage/emulated/0/StatusSaver/pic$curDate.jpg');
          print(newImage);
        }
      }, "Save", Colors.black, Colors.white, true),
      new FabMiniMenuItem.withText(
          new Icon(Icons.share), Colors.teal, 4.0, "Button menu", () async {
        await _shareImage();
      }, "Share", Colors.black, Colors.white, true),
    ];

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
            new FabDialer(
                _fabMiniMenuItemList, Colors.teal, new Icon(Icons.add)),
          ],
        ),
      ),
    );
  }
}
