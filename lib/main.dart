import 'package:covid_vaccine_notifier/model/notificationdata.dart';
import 'package:covid_vaccine_notifier/services/Language_Update/AppTranslation.dart';
import 'package:covid_vaccine_notifier/services/Language_Update/Application.dart';
import 'package:covid_vaccine_notifier/services/notification_manager.dart';
import 'package:covid_vaccine_notifier/services/shared_pref.dart';
import 'package:covid_vaccine_notifier/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:foreground_service/foreground_service.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:covid_vaccine_notifier/services/find_slot.dart';

void main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  runApp(MyApp());
}
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppTranslationsDelegate _newLocaleDelegate;
  bool is_languaged_changed = false;
  @override
  void initState() {
    _newLocaleDelegate = AppTranslationsDelegate(newLocale: null);
   application.onLocaleChanged = onLocaleChange;
   super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        _newLocaleDelegate,
        const AppTranslationsDelegate(),
        //provides localised strings
        GlobalMaterialLocalizations.delegate,
        //provides RTL support
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: application.supportedLocales(),

      theme: ThemeData(
        primaryColor: Color.fromRGBO(82, 194, 70, 1),
        errorColor: Colors.red,
      ),
      debugShowCheckedModeBanner: false,
      home: Wrapper(isStarted: true,),
    );
  }

  void onLocaleChange(Locale locale) {
     setState(() {
      _newLocaleDelegate = AppTranslationsDelegate(newLocale: locale);
    });
  }
}

void maybeStartFGS() async {
  if (!(await ForegroundService.foregroundServiceIsStarted())) {
    await ForegroundService.setServiceIntervalSeconds(10);
    await ForegroundService.notification.startEditMode();
    Active_Notification_Modal notification_modal =
        await SharedPref().get_active_notification_modal();
    print("THis is new center ${notification_modal.center_detail}");
    await ForegroundService.notification.setTitle("COVAC HELPER");
    await ForegroundService.notification.setText(
        "Reminder is active for ${!notification_modal.is_pin_search ? "" : "pincode "}${notification_modal.center_detail} for Age ${notification_modal.age_selected}+");
    await ForegroundService.notification.finishEditMode();
    await ForegroundService.startForegroundService(foregroundServiceFunction);
    await ForegroundService.getWakeLock();
  }
  await ForegroundService.setupIsolateCommunication((data) {
    debugPrint("main received: $data");
  });
}

void foregroundServiceFunction() async {
  Active_Notification_Modal active_notification_modal =
      await SharedPref().get_active_notification_modal();
  String url = await SharedPref().get_string("url");
  Notification_Founded_Modal notificationModal =
      await FindSlot().get_slot(url, active_notification_modal);
  bool slot_status = notificationModal.founded;
  if (slot_status) {
    await NotificationManager().initialize_notification();
    await NotificationManager().newNotification(
        "Click here to book your slot",
        "${notificationModal.capacity} slots founded at ${!notificationModal.is_pin_search ? "" : "pincode "}${notificationModal.center_detail} for Age ${notificationModal.age_selected} +",
        true);
    if (!ForegroundService.isIsolateCommunicationSetup) {
      ForegroundService.setupIsolateCommunication((data) {
        debugPrint("bg isolate received: $data");
      });
    }
    ForegroundService.sendToPort("message from bg isolate");
  }
}
