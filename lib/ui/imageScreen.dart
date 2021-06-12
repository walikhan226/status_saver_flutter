import 'package:save_status_/downloadedscreens/image_view.dart';
import 'package:save_status_/ui/viewphotos.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

//final Directory _photoDir =  new Directory('/storage/emulated/0/WhatsApp/Media/.Statuses');

class ImageScreen extends StatefulWidget {
  final String path;
  final String state;
  ImageScreen({@required this.path, @required this.state});
  @override
  ImageScreenState createState() => new ImageScreenState();
}

class ImageScreenState extends State<ImageScreen>
    with AutomaticKeepAliveClientMixin<ImageScreen> {
  Directory _photoDir;
  @override
  void initState() {
    super.initState();
    _photoDir = new Directory(widget.path);
  }

  @override
  Widget build(BuildContext context) {
    if (!Directory("${widget.path}").existsSync()) {
      return Container(
        padding: EdgeInsets.only(bottom: 60.0),
        child: Center(
          child: Text(
            "Install WhatsApp\nYour Friend's Status Will Be Available Here",
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      );
    } else {
      var imageList = _photoDir
          .listSync()
          .reversed
          .map((item) => item.path)
          .where((item) => item.endsWith(".jpg"))
          .toList(growable: false);

      if (imageList.length > 0) {
        return RefreshIndicator(
          onRefresh: () async {
            imageList = [];
            imageList = await _photoDir
                .listSync()
                .reversed
                .map((item) => item.path)
                .where((item) => item.endsWith(".jpg"))
                .toList(growable: false);
            setState(() {});
          },
          child: Container(
            padding: EdgeInsets.only(bottom: 60.0),
            child: StaggeredGridView.countBuilder(
              padding: EdgeInsets.all(8.0),
              itemCount: imageList.length,
              crossAxisCount: 4,
              itemBuilder: (context, index) {
                String imgPath = imageList[index];
                return Material(
                  elevation: 8.0,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  child: InkWell(
                    onTap: () async {
                      if (widget.state == 'main') {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new ViewPhotos(imgPath)));
                        return;
                      }

                      if (widget.state == 'download') {
                        var val = await Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) =>
                                    new ImageView(imgPath))).then((value) {
                          setState(() {});
                        });
                        return;
                      }
                    },
                    child: Hero(
                        tag: imgPath,
                        child: Image.file(
                          File(imgPath),
                          fit: BoxFit.cover,
                        )),
                  ),
                );
              },
              staggeredTileBuilder: (i) =>
                  StaggeredTile.count(2, i.isEven ? 2 : 3),
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
            ),
          ),
        );
      } else {
        return Scaffold(
          body: Center(
            child: new Container(
                padding: EdgeInsets.only(bottom: 60.0),
                child: Text(
                  'Sorry, No Image Found!',
                  style: TextStyle(fontSize: 18.0),
                )),
          ),
        );
      }
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
