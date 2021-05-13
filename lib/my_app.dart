import 'dart:async';
import 'dart:typed_data';
import 'package:in_app_update/in_app_update.dart';
import 'package:covid_vaccine_notifier/screens/center_list.dart';
import 'package:covid_vaccine_notifier/services/find_slot.dart';
import 'package:covid_vaccine_notifier/widgets/ad_helper.dart';
import 'package:covid_vaccine_notifier/widgets/banner_add.dart';
import 'package:covid_vaccine_notifier/widgets/interstital_ad.dart';
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

  AppUpdateInfo  _updateInfo;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  bool _flexibleUpdateAvailable = false;
  bool _isPinSearch = true;
  InterstitialAd _interstitialAd;
  TextEditingController pin_controller = new TextEditingController();
  int district_id;

  @override
  void initState() {
    checkForUpdate();
     super.initState();
   }
  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        _updateInfo = info;
      });
     }).catchError((e) {
        print("Error fetching the update details");
     });
    _updateInfo?.updateAvailability ==
        UpdateAvailability.updateAvailable
        ?InAppUpdate.performImmediateUpdate()
          .catchError((e) =>  print("unable to update")):null;
    }


  @override
  void dispose() {
     super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('COVAC HELPER'),
      ),
       body: Stack(
        children: [
          Container(
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
                                color: !_isPinSearch ? Colors.white : Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(5)),
                            padding:
                                EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                            child: Center(
                              child: Text(
                                "Search By PIN",
                                style: TextStyle(
                                    color:
                                        _isPinSearch ? Colors.white : Theme.of(context).primaryColor,
                                    fontSize: 14),
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
                                color: _isPinSearch ? Colors.white : Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(5)),
                            padding:
                                EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                            child: Center(
                              child: Text("Search By District",
                                  style: TextStyle(
                                      color: !_isPinSearch
                                          ? Colors.white
                                          : Theme.of(context).primaryColor,
                                      fontSize: 14)),
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
                          : Center(
                            child: StateDistrictForm(
                                notify_parent: (val) {
                                  setState(() {
                                    district_id = val;
                                  });
                                },
                              ),
                          )),
                  SizedBox(
                    height: 20,
                  ),
                  MaterialButton(
                    color: Theme.of(context).primaryColor,
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

                ],
              )),
          Align(
            alignment:Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children:[
                Container(
                    child: BannerAdWidget(AdSize.banner,AdHelper.bannerAdUnitId2)),
                Container(
                    child: BannerAdWidget(AdSize.banner,AdHelper.bannerAdUnitId1)),
              ],
            ),
          ),
        ],
      ),
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
          borderSide: BorderSide(color:Theme.of(context).primaryColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
    );
  }

}
