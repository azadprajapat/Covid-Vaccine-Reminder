
import 'package:covid_vaccine_notifier/screens/HomePage/home_page.dart';
import 'package:covid_vaccine_notifier/screens/Loading_screen.dart';
import 'package:covid_vaccine_notifier/screens/cowin_webview.dart';
import 'package:covid_vaccine_notifier/services/Language_Update/AppTranslation.dart';
import 'package:covid_vaccine_notifier/services/Language_Update/Application.dart';
import 'package:covid_vaccine_notifier/services/backgroundservices.dart';
import 'package:covid_vaccine_notifier/services/shared_pref.dart';
import 'package:covid_vaccine_notifier/widgets/interstital_ad.dart';
import 'package:covid_vaccine_notifier/widgets/select_language.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:foreground_service/foreground_service.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_update/in_app_update.dart';

class Wrapper extends StatefulWidget {
  bool isStarted;
  Wrapper({this.isStarted});
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> with WidgetsBindingObserver{
  AppUpdateInfo  _updateInfo;
  InterstitialAd _interstitialAd;
  bool is_languaged_changed=false;
  FlutterLocalNotificationsPlugin plugin=FlutterLocalNotificationsPlugin();
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch(state) {
      case AppLifecycleState.resumed:
      {

        print("App is resumed");
        plugin.getNotificationAppLaunchDetails().then((value)async {
          if(value.didNotificationLaunchApp){
            bool status = await ForegroundService.foregroundServiceIsStarted();
            if(status) {
              await Background_Services().toggleForegroundServiceOnOff(context);
            }
            await  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>Cowin_Web_View()), (route) => false);
          }
        });
      }
        break;
      case AppLifecycleState.inactive:

        print("App is inactive");
      // Handle this case
        break;
      case AppLifecycleState.paused:

        print("App is paused");
      // Handle this case
        break;
    }
  }
  @override
  void initState() {
    Interstitial_Ad().initialize_ad(_interstitialAd, true,true);
    plugin.getNotificationAppLaunchDetails().then((value)async {
      if(!widget.isStarted){
        return;
      }
      if(value.didNotificationLaunchApp){
        print("launched by the notification");
        bool status = await ForegroundService.foregroundServiceIsStarted();
        if(status) {
          await Background_Services().toggleForegroundServiceOnOff(context);
        }
        await  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>Cowin_Web_View()), (route) => false);
      }
    });
    get_language_from_cache();
    checkForUpdate();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  void get_language_from_cache()async{
    String code = await SharedPref().get_string("language");
     if(code=="en"||code=="hz"){
      await application.onLocaleChanged(Locale(code));
        verify_language_initialisation();
    }else{
       showDialog(context: context, builder: (context){
         return Select_language(notifyParent:  verify_language_initialisation,);
       });
     }
  }
  Future<void>  verify_language_initialisation(){
    setState(() {
      is_languaged_changed=true;
    });
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
  Widget build(BuildContext context) {
    return is_languaged_changed?HomePage():Loading_Screen();
  }
}
