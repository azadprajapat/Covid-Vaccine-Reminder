import 'dart:io';

class AdHelper {

  static String get bannerAdUnitId1 {
    if (Platform.isAndroid) {
      return 'ca-app-pub-5438812424351076/7252344809';
    }
  }
  static String get bannerAdUnitId2 {
    if (Platform.isAndroid) {
      return 'ca-app-pub-5438812424351076/5906779018';
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
     // return 'ca-app-pub-3940256099942544/1033173712';
      return 'ca-app-pub-5438812424351076/8351773671';
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-5438812424351076/5939263130';
    }
  }

}