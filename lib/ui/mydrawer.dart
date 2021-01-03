import 'package:firebase_admob/firebase_admob.dart';
import 'package:save_status_/ui/addmanager.dart';
import 'package:save_status_/ui/savescreen.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';

class MyNavigationDrawer extends StatefulWidget {
  @override
  _MyNavigationDrawerState createState() => _MyNavigationDrawerState();
}

class _MyNavigationDrawerState extends State<MyNavigationDrawer> {
  final String version = '0.3+2';

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  loadRewardedAd() async {
    await RewardedVideoAd.instance.load(
      targetingInfo: MobileAdTargetingInfo(),
      adUnitId: AdManager.rewardedAdUnitId,
    );
  }

  @override
  void initState() {
    loadRewardedAd();
    super.initState();
    //RewardedVideoAd.instance.listener = _onRewardedAdEvent;
  }

  @override
  void dispose() {
    RewardedVideoAd.instance.listener = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height / 6,
          color: Colors.teal,
          child: Center(
            child: Text(
              "Save Status",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width * 0.09),
            ),
          ),
        ),

        // Card(
        //   child: ListTile(
        //     leading: IconTheme(
        //         data: new IconThemeData(color: Color(0xff757575)),
        //         child: Icon(Icons.perm_media)),
        //     title: Text('Premium'),
        //     onTap: () async {
        //       await RewardedVideoAd.instance.show();
        //     },
        //   ),
        // ),
        // Card(
        //   child: ListTile(
        //     leading: IconTheme(
        //         data: new IconThemeData(color: Color(0xff757575)),
        //         child: Icon(Icons.perm_media)),
        //     title: Text('Downloaded Status'),
        //     onTap: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(builder: (context) => SaveScreen()),
        //       );
        //     },
        //   ),
        // ),
        Card(
          child: ListTile(
            leading: IconTheme(
                data: new IconThemeData(color: Color(0xff757575)),
                child: Icon(Icons.info)),
            title: Text('About Us'),
            onTap: () {
              _launchURL('http://remerse.com/');
            },
          ),
        ),
        Card(
          child: ListTile(
            leading: IconTheme(
                data: new IconThemeData(color: Color(0xff757575)),
                child: Icon(Icons.rate_review)),
            title: Text('Rate Us'),
            onTap: () {
              _launchURL(
                  'https://play.google.com/store/apps/details?id=com.remerse.savestatus');
            },
          ),
        ),
        Card(
          child: ListTile(
            leading: IconTheme(
                data: new IconThemeData(color: Color(0xff757575)),
                child: Icon(Icons.share)),
            title: Text('Share With Friends'),
            onTap: () {
              Share.share(
                  'https://play.google.com/store/apps/details?id=com.remerse.savestatus',
                  subject: '');
            },
          ),
        ),
        // Card(
        //   child: ListTile(
        //     leading: IconTheme(
        //         data: new IconThemeData(color: Color(0xff757575)),
        //         child: Icon(Icons.settings)),
        //     title: Text('Settings'),
        //     onTap: () {},
        //   ),
        // ),
      ],
    );
  }
}
