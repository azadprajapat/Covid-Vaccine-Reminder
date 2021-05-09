import 'package:covid_vaccine_notifier/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:foreground_service/foreground_service.dart';
import 'package:permission_handler/permission_handler.dart';
import '../widgets/CenterCard.dart';
import 'package:flutter_background/flutter_background.dart';
import '../model/center_modal.dart';
import 'package:covid_vaccine_notifier/services/find_slot.dart';

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
    notification_status();
    super.initState();
    _controller = EasyRefreshController();
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
    original_list =
    await FindSlot().search_center(widget.url);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Vaccination center list'),
          actions: [
            InkWell(
                onTap: () {
                  notification_handler();
                 },
                child: Icon(
                  is_alert_active ? Icons.notifications_active_rounded : Icons
                      .add_alert, color: Colors.white,)),
            SizedBox(width: 10,),
          ],
        ),
        body: Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: MediaQuery
              .of(context)
              .size
              .height,
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
              style: TextStyle(color: Colors.red),
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
            child: EasyRefresh.custom(
                key: _refreshIndicatorKey,
                header: BallPulseHeader(color: Colors.green),
                onRefresh: _handleRefresh,
                slivers: <Widget>[
                  SliverList(
                    delegate:
                    SliverChildBuilderDelegate((context, index) {
                      if (index == 0) {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: List.generate(
                                  filters.length,
                                      (index) =>
                                      InkWell(
                                          onTap: () {
                                            setState(() {
                                              filter_map[filters[index]] =
                                              !filter_map[filters[index]];
                                            });
                                            manage_filter(filters[index]);
                                          },
                                          child: filter_pills(filters[index],
                                              filter_map[filters[index]]))),
                            ),
                            SizedBox(height: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("All Available Slots", style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),),
                                Text("Age 18+ :  ${all_18_session == 0
                                    ? "Booked"
                                    : all_18_session.toString()}",
                                  style: TextStyle(fontSize: 14,
                                      fontWeight: FontWeight.w400),),
                                Text("Age 45+ :  ${all_45_session == 0
                                    ? "Booked"
                                    : all_45_session.toString()}",
                                  style: TextStyle(fontSize: 14,
                                      fontWeight: FontWeight.w400),),
                              ],
                            ),
                            SizedBox(height: 10,),
                          ],
                        );
                      }
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
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

  Widget filter_pills(text, bool is_active) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.green),
          color: !is_active ? Colors.white : Colors.green),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
              fontSize: 12, color: is_active ? Colors.white : Colors.green),
        ),
      ),
    );
  }

  void notification_handler() async {
    Permission.ignoreBatteryOptimizations.request();
   PermissionStatus hasPermissions = await Permission.ignoreBatteryOptimizations.status;
    if(!hasPermissions.isGranted){
      return;
    }
    if (is_alert_active) {
      setState(() {
        is_alert_active = !is_alert_active;
      });
      _toggleForegroundServiceOnOff(context);
      return;
    }
    _toggleForegroundServiceOnOff(context);
    setState(() {
      is_alert_active=!is_alert_active;
    });
    if (is_alert_active) {
      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              content: Text(
                  "Notification Active"),
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
  }
}
