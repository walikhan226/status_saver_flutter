import 'package:facebook_audience_network/ad/ad_interstitial.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';

class MyNavigationDrawer extends StatefulWidget {
  @override
  _MyNavigationDrawerState createState() => _MyNavigationDrawerState();
}

class _MyNavigationDrawerState extends State<MyNavigationDrawer> {
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: <Widget>[
        Container(
          height: 30,
          color: Color(0xFF096157),
        ),
        Container(
          height: MediaQuery.of(context).size.height / 6,
          color: Color(0xFF096157),
          child: Center(
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Image.asset("assets/images/icon.png",
                    height: MediaQuery.of(context).size.height * 0.09),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Save Status",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.09),
                ),
              ],
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
