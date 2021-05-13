import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_helper.dart';

class Interstitial_Ad {
  bool _interstitialReady = false;

  void initialize_ad(_interstitialAd, bool delayed) {
    MobileAds.instance.initialize().then((InitializationStatus status) {
      print('Initialization done: ${status.adapterStatuses}');
      MobileAds.instance
          .updateRequestConfiguration(RequestConfiguration(
              tagForChildDirectedTreatment:
                  TagForChildDirectedTreatment.unspecified))
          .then((void value) {
        createInterstitialAd(_interstitialAd, delayed);
      });
    });
  }

  void createInterstitialAd(_interstitialAd, delayed) {
    _interstitialAd ??= InterstitialAd(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      listener: AdListener(
        onAdLoaded: (Ad ad) {
          print('${ad.runtimeType} loaded.');
          _interstitialReady = true;
          if (!delayed) {
            _interstitialAd.show();
          } else {
            Future.delayed(Duration(minutes: 2), () {
              _interstitialAd.show();
            });
          }
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('${ad.runtimeType} failed to load: $error.');
          ad.dispose();
          _interstitialAd = null;
          createInterstitialAd(_interstitialAd, delayed);
        },
        onAdOpened: (Ad ad) => print('${ad.runtimeType} onAdOpened.'),
        onAdClosed: (Ad ad) async {
          print('${ad.runtimeType} closed.');
          ad.dispose();
          createInterstitialAd(_interstitialAd, delayed);
        },
        onApplicationExit: (Ad ad) =>
            print('${ad.runtimeType} onApplicationExit.'),
      ),
    )..load();
  }
}
