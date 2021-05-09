import 'dart:async';
import 'dart:typed_data';

import 'package:covid_vaccine_notifier/screens/center_list.dart';
import 'package:covid_vaccine_notifier/services/find_slot.dart';
import 'package:covid_vaccine_notifier/widgets/ad_helper.dart';
import 'package:covid_vaccine_notifier/widgets/banner_add.dart';
import 'package:covid_vaccine_notifier/widgets/state_district_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  InterstitialAd _interstitialAd;
  bool _interstitialReady = false;

  bool _isPinSearch = true;
  TextEditingController pin_controller = new TextEditingController();
  int district_id;

  @override
  void initState() {
     MobileAds.instance.initialize().then((InitializationStatus status) {
      print('Initialization done: ${status.adapterStatuses}');
      MobileAds.instance
          .updateRequestConfiguration(RequestConfiguration(
              tagForChildDirectedTreatment:
                  TagForChildDirectedTreatment.unspecified))
          .then((void value) {
        createInterstitialAd();
      });
    });
    super.initState();
  }

  void createInterstitialAd() {
    _interstitialAd ??= InterstitialAd(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      listener: AdListener(
        onAdLoaded: (Ad ad) {
          print('${ad.runtimeType} loaded.');
          _interstitialReady = true;
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('${ad.runtimeType} failed to load: $error.');
          ad.dispose();
          _interstitialAd = null;
          createInterstitialAd();
        },
        onAdOpened: (Ad ad) => print('${ad.runtimeType} onAdOpened.'),
        onAdClosed: (Ad ad) {
          print('${ad.runtimeType} closed.');
          ad.dispose();
          createInterstitialAd();
        },
        onApplicationExit: (Ad ad) =>
            print('${ad.runtimeType} onApplicationExit.'),
      ),
    )..load();
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Covid vaccine notifier'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (!_interstitialReady) return;
          _interstitialAd.show();
          _interstitialReady = false;
          _interstitialAd = null;
        },
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.green, width: 1),
                    borderRadius: BorderRadius.circular(5)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _isPinSearch = true;
                        });
                      },
                      child: Container(
                        width: 150 * MediaQuery.of(context).size.width / 360,
                        height: 50,
                        decoration: BoxDecoration(
                            color: !_isPinSearch ? Colors.white : Colors.green,
                            borderRadius: BorderRadius.circular(5)),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Center(
                          child: Text(
                            "Search By PIN",
                            style: TextStyle(
                                color:
                                    _isPinSearch ? Colors.white : Colors.green,
                                fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _isPinSearch = false;
                        });
                      },
                      child: Container(
                        width: 150 * MediaQuery.of(context).size.width / 360,
                        height: 50,
                        decoration: BoxDecoration(
                            color: _isPinSearch ? Colors.white : Colors.green,
                            borderRadius: BorderRadius.circular(5)),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Center(
                          child: Text("Search By District",
                              style: TextStyle(
                                  color: !_isPinSearch
                                      ? Colors.white
                                      : Colors.green,
                                  fontSize: 15)),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                  width: 300 * MediaQuery.of(context).size.width / 360,
                  child: _isPinSearch
                      ? _PinForm()
                      : StateDistrictForm(
                          notify_parent: (val) {
                            setState(() {
                              district_id = val;
                            });
                          },
                        )),
              SizedBox(
                height: 20,
              ),
              MaterialButton(
                color: Colors.green,
                disabledColor: Colors.black38,
                onPressed: () {
                  print(_isPinSearch);
                  print(pin_controller.text.length);
                  if (_isPinSearch && pin_controller.text.length == 6 ||
                      !_isPinSearch && district_id != null) {
                    String url = FindSlot().get_url(_isPinSearch, _isPinSearch
                        ? pin_controller.text
                        : district_id.toString());
                     Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => CenterList(url: url,)));
                  } else {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            content: Text("Enter valid Area pincode"),
                            actions: [
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("Ok"),
                              )
                            ],
                          );
                        });
                  }
                },
                child: Text(
                  "Search",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                height: 20,
              ),

              //  Expanded(
              //   child: TabBarView(
              //       controller: _controller,
              //       children: [
              //         CenterList(),
              //         NotifySession(),
              //       ]),
              // ),
              Container(
                  alignment: Alignment.bottomCenter,
                  child: BannerAdWidget(AdSize.banner)),
            ],
          )),
    );
  }

  Widget _PinForm() {
    return TextField(
      autocorrect: true,
      controller: pin_controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: 'Enter your PIN',
        hintStyle: TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white70,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          borderSide: BorderSide(color: Colors.green, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: Colors.green),
        ),
      ),
    );
  }
}
