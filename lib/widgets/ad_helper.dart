import 'dart:io';

class AdHelper {

  static String get bannerAdUnitId1 {
    if (Platform.isAndroid) {
      return 'ca-app-pub-9565503291787604/4957788725';
    }
  }
  static String get bannerAdUnitId2 {
    if (Platform.isAndroid) {
      return 'ca-app-pub-9565503291787604/7321541264';
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
     // return 'ca-app-pub-3940256099942544/1033173712';
      return 'ca-app-pub-9565503291787604/2069214580';
    }
  }


}