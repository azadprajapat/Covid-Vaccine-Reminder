import 'dart:developer';

import 'package:covid_vaccine_notifier/main.dart';
import 'package:covid_vaccine_notifier/widgets/confirm_notification_box.dart';
import 'package:covid_vaccine_notifier/widgets/filter_pills.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:foreground_service/foreground_service.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import '../widgets/CenterCard.dart';
import '../model/center_modal.dart';
import 'package:covid_vaccine_notifier/services/find_slot.dart';
import 'package:covid_vaccine_notifier/widgets/interstital_ad.dart';

class CenterList extends StatefulWidget {
  final url;
  CenterList({this.url});

  @override
  _CenterListState createState() => _CenterListState();
}

class _CenterListState extends State<CenterList> {

   EasyRefreshController _controller;
  bool fetching = false;
  List<CenterModal> formatted_list = [];
  List<CenterModal> original_list = [];
  InterstitialAd _interstitialAd;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  int all_18_session = 0;
  int all_45_session = 0;

  bool is_alert_active = false;
  List<String> filters = [
    "Age 18+",
    "Age 45+",
    "Covishield",
    "Covaxin",
    "Free",
    "Paid"
  ];
  Map<String, bool> filter_map = {
    "Age 18+": true,
    "Age 45+": true,
    "Covishield": true,
    "Covaxin": true,
    "Free": true,
    "Paid": true
  };


  @override
  void initState() {
    fetch_data();
    Interstitial_Ad().initialize_ad(_interstitialAd, true);
    notification_status();
    super.initState();
     _controller = EasyRefreshController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Slots Availability'),
           actions: [
            Container(
              child: InkWell(
                  onTap: () {
                    notification_handler();
                  },
                  child: Icon(
                    is_alert_active
                        ? Icons.notifications_active_rounded
                        : Icons.add_alert,
                    color: Colors.white,
                  )),
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: fetching
              ? Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : original_list == null
                  ? AlertDialog(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      content: Text(
                        "error while fetching vaccination centers",
                        style: TextStyle(color: Theme.of(context).errorColor),
                      ),
                      actions: [
                        MaterialButton(
                          onPressed: () async {
                            setState(() {
                              fetching = true;
                            });
                            await Future.delayed(Duration(seconds: 1));
                            await fetch_data();
                          },
                          child: Text("Refresh"),
                        ),
                      ],
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: original_list.length == 0
                          ? Center(
                              child: Text(
                                "No Vaccination center is available",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                              ),
                            )
                          : EasyRefresh.custom(
                              key: _refreshIndicatorKey,
                              header: BallPulseHeader(
                                  color: Theme.of(context).primaryColor),
                              onRefresh: _handleRefresh,
                              slivers: <Widget>[
                                  SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                        (context, index) {
                                      if (index == 0) {
                                        return Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: List.generate(
                                                  filters.length,
                                                  (index) => InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          filter_map[filters[
                                                                  index]] =
                                                              !filter_map[
                                                                  filters[
                                                                      index]];
                                                        });
                                                        manage_filter(
                                                            filters[index]);
                                                      },
                                                      child: filter_pills(
                                                          filters[index],
                                                          filter_map[
                                                              filters[index]],
                                                          context))),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            original_list.length != 0
                                                ? Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "All Available Slots",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      Text(
                                                        "Age 18+ :  ${all_18_session == 0 ? "Booked" : all_18_session.toString()}",
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                      Text(
                                                        "Age 45+ :  ${all_45_session == 0 ? "Booked" : all_45_session.toString()}",
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                    ],
                                                  )
                                                : Container(),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        );
                                      }
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: InkWell(
                                          child: CenterCard(
                                            modal: formatted_list[index - 1],
                                            filter_map: filter_map,
                                          ),
                                        ),
                                      );
                                    }, childCount: formatted_list.length + 1),
                                  ),
                                ]),
                    ),
        ));
  }

  Future<Null> _handleRefresh() async {
    _refreshIndicatorKey.currentState?.show(atTop: false);
    await fetch_data();
  }

  void notification_handler() async {
    await Permission.ignoreBatteryOptimizations.request();
    PermissionStatus hasPermissions =
        await Permission.ignoreBatteryOptimizations.status;
    if (!hasPermissions.isGranted) {
      return;
    }
    if (is_alert_active) {
      setState(() {
        is_alert_active = !is_alert_active;
      });
      _toggleForegroundServiceOnOff(context);
      InterstitialAd _interstitalAd;
      Interstitial_Ad().initialize_ad(_interstitalAd, false);
      return;
    } else {
      bool is_age_18 = true;
      showDialog(
          context: context,
          builder: (_) {
            return ConfirmNotificationBox(notify_parent: () {
              _toggleForegroundServiceOnOff(context);
              setState(() {
                is_alert_active = !is_alert_active;
              });
            });
          });
    }
  }

  void _toggleForegroundServiceOnOff(context) async {
    final fgsIsRunning = await ForegroundService.foregroundServiceIsStarted();
    if (fgsIsRunning) {
      await ForegroundService.stopForegroundService();
    } else {
      maybeStartFGS();
    }
  }

  void notification_status() async {
    bool status = await ForegroundService.foregroundServiceIsStarted();
    setState(() {
      is_alert_active = status;
    });
  }

  void fetch_data() async {
    setState(() {
      fetching = true;
    });
    original_list = await FindSlot().search_center(widget.url);
    setState(() {
      all_18_session = 0;
      all_45_session = 0;
      fetching = false;
      formatted_list = original_list;
      filters.forEach((element) {
        filter_map[element] = true;
      });
      original_list.forEach((element) {
        element.sessions.forEach((element) {
          if (element.age_limit == 18) {
            setState(() {
              all_18_session += element.seat_availablity;
            });
          }
          if (element.age_limit == 45) {
            setState(() {
              all_45_session += element.seat_availablity;
            });
          }
        });
      });
    });
  }

  void manage_filter(filter_name) {
    switch (filter_name) {
      case "Free":
        {
          if (filter_map[filter_name]) {
            setState(() {
              formatted_list.addAll(
                  original_list.where((e) => e.fee_type == "Free").toList());
            });
          } else {
            setState(() {
              formatted_list =
                  formatted_list.where((e) => e.fee_type != "Free").toList();
            });
          }
        }
        break;
      case "Paid":
        {
          if (filter_map[filter_name]) {
            setState(() {
              formatted_list.addAll(
                  original_list.where((e) => e.fee_type == "Paid").toList());
            });
          } else {
            setState(() {
              formatted_list =
                  formatted_list.where((e) => e.fee_type != "Paid").toList();
            });
          }
        }
        break;
    }
  }
}
