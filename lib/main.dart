import 'package:covid_vaccine_notifier/model/notificationdata.dart';
import 'package:covid_vaccine_notifier/services/notification_manager.dart';
import 'package:flutter/material.dart';
import 'package:foreground_service/foreground_service.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'my_app.dart';
import 'package:covid_vaccine_notifier/services/find_slot.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp( MaterialApp(
            theme: ThemeData(
                primaryColor: Colors.green
            ),
            debugShowCheckedModeBanner: false,
            home: MyApp())
      );
}
void maybeStartFGS() async {
     if (!(await ForegroundService.foregroundServiceIsStarted())) {

    await ForegroundService.setServiceIntervalSeconds(10);
    await ForegroundService.notification.startEditMode();
    await ForegroundService.notification.setTitle("Covid Vaccine notifier");
    await ForegroundService.notification.setText("Covid Vaccine slot finder started running in background");
    await ForegroundService.notification.finishEditMode();
    await ForegroundService.startForegroundService(foregroundServiceFunction);
    await ForegroundService.setContinueRunningAfterAppKilled(true);
    await ForegroundService.getWakeLock();
  }
  await ForegroundService.setupIsolateCommunication((data) {
    debugPrint("main received: $data");
  });
}

  void foregroundServiceFunction() async {
  NotificationModal notificationModal =  await FindSlot().get_slot();
  bool slot_status = notificationModal.founded;
    if (slot_status) {
     await NotificationManager().initialize_notification();
      await NotificationManager().newNotification("${notificationModal.capacity} slots founded for Age ${notificationModal.age}+", "Hurry Up Book Fast !!", true);
       if (!ForegroundService.isIsolateCommunicationSetup) {
        ForegroundService.setupIsolateCommunication((data) {
          debugPrint("bg isolate received: $data");
        });
      }
      ForegroundService.sendToPort("message from bg isolate");
    }
  }

