import 'dart:io';

class AdManager {
  static String get appId {
    if (Platform.isAndroid) {
      return "ca-app-pub-6637457000724205~7863779043";
    } else if (Platform.isIOS) {
      return "ca-app-pub-6637457000724205~7863779043";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-6637457000724205/2049163826";
    } else if (Platform.isIOS) {
      return "ca-app-pub-6637457000724205/2049163826";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  // static String get interstitialAdUnitId {
  //   if (Platform.isAndroid) {
  //     return "ca-app-pub-6637457000724205/5049612128";
  //   } else if (Platform.isIOS) {
  //     return "ca-app-pub-6637457000724205~9516482507";
  //   } else {
  //     throw new UnsupportedError("Unsupported platform");
  //   }
  // }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-6637457000724205/8237267846";
    } else if (Platform.isIOS) {
      return "ca-app-pub-6637457000724205/8237267846";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}
