import 'package:covid_vaccine_notifier/model/notificationdata.dart';
import 'package:covid_vaccine_notifier/services/Language_Update/AppTranslation.dart';
import 'package:covid_vaccine_notifier/services/backgroundservices.dart';
import 'package:covid_vaccine_notifier/services/shared_pref.dart';
import 'package:covid_vaccine_notifier/widgets/interstital_ad.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:foreground_service/foreground_service.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class ActiveNotificationBox extends StatefulWidget {
  @override
  _ActiveNotificationBoxState createState() => _ActiveNotificationBoxState();
}

class _ActiveNotificationBoxState extends State<ActiveNotificationBox> {
  bool status = true;
  InterstitialAd _interstitial_ad;

  @override
  void didUpdateWidget(covariant ActiveNotificationBox oldWidget) {
    ForegroundService.foregroundServiceIsStarted().then((value) => setState(() {
          status = value;
        }));
    super.didUpdateWidget(oldWidget);
  }
  @override
  Widget build(BuildContext context) {
    double width = 300 * MediaQuery.of(context).size.width / 360;
    return FutureBuilder(
      builder: (context, isactive) {
        if (isactive.connectionState == ConnectionState.waiting) {
          print("waiting for notification status");
          return Container();
        }
        if (isactive.data == null || !isactive.data) {
          print("notification staus system data is null");
          return Container();
        }
        return FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              print("waiting");
              return Container();
            }
            if (snapshot.data == null) {
              return Container();
            }
            Active_Notification_Modal notification_modal =
                Active_Notification_Modal(
                    age_selected: snapshot.data.age_selected,
                    center_detail: snapshot.data.center_detail,
                    is_pin_search: snapshot.data.is_pin_search);
            return Container(
              margin: EdgeInsets.only(bottom: 50),
              child: Card(
                color:Theme.of(context).primaryColor,
                elevation: 16,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Container(
                  width: width,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                      AppTranslations.of(context).text("Active Notification"),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Row(
                               mainAxisSize: MainAxisSize.min,
                               children: [
                                 Text(
                                   notification_modal.is_pin_search
                                       ? AppTranslations.of(context).text("Pincode:")
                                       : AppTranslations.of(context).text("Location:"),
                                   style: TextStyle(
                                       color: Colors.white,
                                       fontSize: 14, fontWeight: FontWeight.w500),
                                 ),
                                 SizedBox(
                                   width: 10,
                                 ),
                                 Text(
                                   notification_modal.center_detail,
                                   style: TextStyle(
                                       color: Colors.white,
                                       fontSize: 14, fontWeight: FontWeight.w600),
                                 ),
                               ],
                             ),
                             Row(
                               mainAxisSize: MainAxisSize.min,
                               children: [
                                 Text(
                                   AppTranslations.of(context).text("Age:"),
                                   style: TextStyle(
                                       color: Colors.white,
                                       fontSize: 14, fontWeight: FontWeight.w500),
                                 ),
                                 SizedBox(
                                   width: 10,
                                 ),
                                 Text(
                                   "${notification_modal.age_selected}+",
                                   style: TextStyle(
                                       color: Colors.white,
                                       fontSize: 14, fontWeight: FontWeight.w600),
                                 ),
                               ],
                             ),
                           ],
                         ),
                         Transform.scale(
                           scale: 0.9,
                           child: CupertinoSwitch(
                               value: status,
                               dragStartBehavior: DragStartBehavior.start,
                               activeColor: Colors.blue,
                               trackColor: Colors.blue.withOpacity(0.4),
                               onChanged: (value) async {
                                 setState(() {
                                   status = value;
                                 });
                                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                   content: Text(AppTranslations.of(context).text('Notification reminder has been disabled')),
                                 ));
                                 Future.delayed(Duration(seconds: 1),()async{
                                   await Background_Services()
                                       .toggleForegroundServiceOnOff(context);
                                   setState(() {
                                   });
                                   Interstitial_Ad().createInterstitialAd(_interstitial_ad,false,false);

                                 });
                               }),
                         )
                       ],
                     ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              ),
            );
          },
          future: SharedPref().get_active_notification_modal(),
        );
      },
      future: ForegroundService.foregroundServiceIsStarted(),
    );
  }
}
