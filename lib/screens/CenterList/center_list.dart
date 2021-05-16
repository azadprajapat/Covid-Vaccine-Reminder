import 'package:covid_vaccine_notifier/model/notificationdata.dart';
import 'package:covid_vaccine_notifier/services/Language_Update/AppTranslation.dart';
import 'package:covid_vaccine_notifier/services/backgroundservices.dart';
import 'package:covid_vaccine_notifier/services/shared_pref.dart';
import 'package:covid_vaccine_notifier/widgets/alert_fab.dart';
import 'package:covid_vaccine_notifier/widgets/confirm_notification_box.dart';
import 'package:covid_vaccine_notifier/widgets/filter_pills.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:foreground_service/foreground_service.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../widgets/CenterCard.dart';
import '../../model/center_modal.dart';
import 'package:covid_vaccine_notifier/services/find_slot.dart';

class CenterList extends StatefulWidget {
  String url;
  bool is_pin_search;
  String center_detail;

  CenterList({this.url, this.is_pin_search, this.center_detail});

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
    _controller = EasyRefreshController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppTranslations.of(context).text('Slots Availability'),
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: IconThemeData(color: Colors.white),
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
                        AppTranslations.of(context).text("error while fetching vaccination centers"),
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
                  : Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: original_list.length == 0
                              ? Center(
                                  child: Text(
                                    AppTranslations.of(context).text("No Vaccination centers are available"),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
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
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: List.generate(
                                                      3,
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
                                                                  filters[
                                                                      index]],
                                                              context))),
                                                ),
                                                SizedBox(height: 8,),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceEvenly,
                                                  children: List.generate(
                                                      3,
                                                          (index) => InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              filter_map[filters[
                                                              index+3]] =
                                                              !filter_map[
                                                              filters[
                                                              index+3]];
                                                            });
                                                            manage_filter(
                                                                filters[index+3]);
                                                          },
                                                          child: filter_pills(
                                                              filters[index+3],
                                                              filter_map[
                                                              filters[
                                                              index+3]],
                                                              context))),
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                original_list.length != 0
                                                    ? Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                              AppTranslations.of(context).text("ALL AVAILABLE SLOTS"),
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                color: Theme.of(context).primaryColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                "${AppTranslations.of(context).text("AGE 18+")} :  ${all_18_session == 0 ?AppTranslations.of(context).text("BOOKED") : all_18_session.toString()}",
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                              ),
                                                              Text(
                                                                "${AppTranslations.of(context).text("AGE 45+")} :  ${all_45_session == 0 ? AppTranslations.of(context).text("BOOKED") : all_45_session.toString()}",
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                              ),
                                                            ],
                                                          )
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
                                                modal:
                                                    formatted_list[index - 1],
                                                filter_map: filter_map,
                                              ),
                                            ),
                                          );
                                        },
                                            childCount:
                                                formatted_list.length + 1),
                                      ),
                                    ]),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            margin: EdgeInsets.only(bottom: 20),
                            child: InkWell(
                                onTap: () {
                                  notification_handler();
                                },
                                child: Notification_Fab()),
                          ),
                        )
                      ],
                    ),
        ));
  }

  Future<Null> _handleRefresh() async {
    _refreshIndicatorKey.currentState?.show(atTop: false);
    await fetch_data();
  }

  void notification_handler() async {
    showDialog(
        context: context,
        builder: (_) {
          return ConfirmNotificationBox(notify_parent: (age_selected) async {
            _on_notification_started(age_selected);
          });
        });
  }

  void _on_notification_started(age_selected) async {
    await Permission.ignoreBatteryOptimizations.request();
    print("permission status completed");
    PermissionStatus hasPermissions =
        await Permission.ignoreBatteryOptimizations.status;
    if (!hasPermissions.isGranted) {
      print("permission is not granted");
      return;
    }

    bool status = await ForegroundService.foregroundServiceIsStarted();
    print("service status ${status}");
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(AppTranslations.of(context).text('Notification reminder is running')),
    ));

    if (status) {
      await Background_Services().toggleForegroundServiceOnOff(context);
    }
    await SharedPref().set_string("url", widget.url);
    await SharedPref().set_active_notification_modal(Active_Notification_Modal(
      age_selected: age_selected,
      is_pin_search: widget.is_pin_search,
      center_detail: widget.center_detail,
    ));

     Future.delayed(Duration(seconds: 1),(){
      Navigator.of(context).pop(true);
    });
    await Background_Services().toggleForegroundServiceOnOff(context);
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
