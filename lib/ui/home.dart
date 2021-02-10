import 'package:mopub_flutter/mopub.dart';
import 'package:mopub_flutter/mopub_banner.dart';
import 'package:mopub_flutter/mopub_interstitial.dart';
import 'package:save_status_/ui/addmanager.dart';
import 'package:save_status_/ui/banneradd.dart';
import 'package:save_status_/ui/dashboard.dart';

import 'package:save_status_/ui/mydrawer.dart';
import 'package:flutter/material.dart';

import 'package:share/share.dart';
import 'package:permission_handler/permission_handler.dart';

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
            RaisedButton(
              elevation: 5,
              padding: EdgeInsets.all(15.0),
              child: Text(
                "Allow Storage Permission",
                style: TextStyle(fontSize: 20.0),
              ),
              textColor: Colors.black,
              onPressed: () async {
                var status = await Permission.storage.status;

                if (status.isUndetermined) {
                  // You can request multiple permissions at once.
                  Map<Permission, PermissionStatus> statuses = await [
                    Permission.storage,
                  ].request();
                  print(statuses[Permission
                      .storage]); // it should print PermissionStatus.granted
                }

                if (status.isGranted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MyHome()),
                  );
                } else {
                  Map<Permission, PermissionStatus> statuses = await [
                    Permission.storage,
                  ].request();
                  print(statuses[Permission.storage]);
                }
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
  MoPubBannerAd moPubBannerAd;
  MoPubInterstitialAd mInterstitial;
  @override
  void dispose() {
    super.dispose();
    mInterstitial?.dispose();
  }

//6b6c2b4fd054432495920692cd535138

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
    } catch (e) {
      print(e.toString());
    }

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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => _scaffoldKey.currentState.openDrawer()),
          title: Text('Save Status'),
          backgroundColor: Color(0xFF096157),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.share),
                onPressed: () {
                  Share.share(
                      'https://play.google.com/store/apps/details?id=com.remerse.savestatus',
                      subject: '');

                  try {
                    mInterstitial.show();
                  } catch (e) {}
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
                                  Expanded(
                                    child: new Align(
                                      alignment: Alignment.bottomRight,
                                      child: FlatButton(
                                        child: Text(
                                          'OK!',
                                          style: TextStyle(color: Colors.green),
                                        ),
                                        onPressed: () async {
                                          try {
                                            mInterstitial.show();
                                            // await mInterstitial.load();
                                            //  await mInterstitial.show();
                                          } catch (e) {
                                            print(e.toString());
                                          }

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
          bottom: TabBar(
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              tabs: [
                Container(
                  height: 30.0,
                  child: Text(
                    'IMAGES',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.035),
                  ),
                ),
                Container(
                  height: 30.0,
                  child: Text(
                    'VIDEOS',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.035),
                  ),
                ),
                Container(
                  height: 30.0,
                  child: Text(
                    'DOWNLOADED',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.035),
                  ),
                ),
              ]),
        ),

        //724225414947921_730137894356673
        body: Dashboard(),

        bottomSheet: Banneradd(),
        backgroundColor: Colors.white,
        drawer: Drawer(
          child: MyNavigationDrawer(),
        ),
      ),
    );
  }
}
