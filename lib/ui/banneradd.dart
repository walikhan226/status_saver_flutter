// import 'package:flutter/material.dart';

// import 'package:facebook_audience_network/ad/ad_banner.dart';

// class Banneradd extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: FacebookBannerAd(
//         placementId: "724225414947921_730137894356673",
//         bannerSize: BannerSize.STANDARD,
//         listener: (result, value) {
//           switch (result) {
//             case BannerAdResult.ERROR:
//               print("Error: $value");
//               break;
//             case BannerAdResult.LOADED:
//               print("Loaded: $value");
//               break;
//             case BannerAdResult.CLICKED:
//               print("Clicked: $value");
//               break;
//             case BannerAdResult.LOGGING_IMPRESSION:
//               print("Logging Impression: $value");
//               break;
//           }
//         },
//       ),
//     );
//   }
// }
