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
      return "ca-app-pub-3940256099942544~3347511713";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544~3347511713";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "	ca-app-pub-3940256099942544/6300978111";
    } else if (Platform.isIOS) {
      return "	ca-app-pub-3940256099942544/6300978111";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/1033173712";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/1033173712";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/5224354917";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/5224354917";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}
