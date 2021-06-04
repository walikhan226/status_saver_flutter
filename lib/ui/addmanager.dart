import 'dart:io';

class AdManager {
  // static String get bannerid {
  //   if (Platform.isAndroid) {
  //     return "5a06bb0ae25a4c16aa220936bf0049c7";
  //   } else if (Platform.isIOS) {
  //     return "5a06bb0ae25a4c16aa220936bf0049c7";
  //   } else {
  //     throw new UnsupportedError("Unsupported platform");
  //   }
  // }

  // static String get interstialid {
  //   if (Platform.isAndroid) {
  //     return "6b6c2b4fd054432495920692cd535138";
  //   } else if (Platform.isIOS) {
  //     return "6b6c2b4fd054432495920692cd535138";
  //   } else {
  //     throw new UnsupportedError("Unsupported platform");
  //   }
  // }

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
      return "ca-app-pub-6637457000724205/9954102137";
    } else if (Platform.isIOS) {
      return "ca-app-pub-6637457000724205/9954102137";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-6637457000724205/5575873427";
    } else if (Platform.isIOS) {
      return "ca-app-pub-6637457000724205/5575873427";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-6637457000724205/1636628419";
    } else if (Platform.isIOS) {
      return "ca-app-pub-6637457000724205/1636628419";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}
