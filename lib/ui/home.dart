import 'package:test123/ui/dashboard.dart';
import 'package:test123/ui/mydrawer.dart';
import 'package:flutter/material.dart';

import 'package:share/share.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:test123/ui/imageScreen.dart';
import 'package:test123/ui/videoScreen.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => new MyAppState();
}

class MyAppState extends State<MyApp> {
  var init = Container();

  checkpermission() async {
    var status = await Permission.storage.status;
    if (status.isUndetermined) {
      // You can request multiple permissions at once.
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();
      print(statuses[
          Permission.storage]); // it should print PermissionStatus.granted
    }

    if (status.isGranted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHome()),
      );
    } else {
      setState(() {
        init = home();
      });
      return;
    }
  }

  Widget home() {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        colors: [
          Colors.lightBlue[100],
          Colors.lightBlue[200],
          Colors.lightBlue[300],
          Colors.lightBlue[200],
          Colors.lightBlue[100],
        ],
      )),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Storage Permission Required",
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            FlatButton(
              padding: EdgeInsets.all(15.0),
              child: Text(
                "Allow Storage Permission",
                style: TextStyle(fontSize: 20.0),
              ),
              color: Colors.indigo,
              textColor: Colors.white,
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MyHome()),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    checkpermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: init,
    );
  }
}

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  var html =
      "<h3><b>How To Use?</b></h3><p>- Check the Desired Status/Story...</p><p>- Come Back to App, Click on any Image or Video to View...</p><p>- Click the Save Button...<br />The Image/Video is Instantly saved to your Galery :)</p><p>- You can also Use Multiple Saving. [to do]</p>";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => _scaffoldKey.currentState.openDrawer()),
        title: Text('Status Saver'),
        backgroundColor: Colors.teal,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                Share.share(
                    'check out my wa status downloader https://mastersam.io',
                    subject: 'Look what I made!');
              }),
          IconButton(
              icon: Icon(Icons.help_outline),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        child: Container(
                          height: 400,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Html(data: html),
                                Expanded(
                                  child: new Align(
                                    alignment: Alignment.bottomRight,
                                    child: FlatButton(
                                      child: Text(
                                        'OK!',
                                        style: TextStyle(color: Colors.green),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              })
        ],
        bottom: TabBar(tabs: [
          Container(
            height: 30.0,
            child: Text(
              'IMAGES',
            ),
          ),
          Container(
            height: 30.0,
            child: Text(
              'VIDEOS',
            ),
          ),
        ]),
      ),
      body: DefaultTabController(
        length: 2,
        child: TabBarView(
          children: [
            ImageScreen(),
            VideoScreen(),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      drawer: Drawer(
        child: MyNavigationDrawer(),
      ),
    );
  }
}
