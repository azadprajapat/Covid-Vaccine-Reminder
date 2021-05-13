import 'dart:typed_data';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationManager{
  var plugin = FlutterLocalNotificationsPlugin();
  Future<void> initialize_notification(){
    final initializationSettings = InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: IOSInitializationSettings());
    plugin.initialize(initializationSettings);
  }
  Future<void> newNotification( String title,String msg,bool vibration) async {
    // Define vibration pattern
    var vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    AndroidNotificationDetails androidNotificationDetails;

    final channelName = 'Text messages';

    androidNotificationDetails = AndroidNotificationDetails(
        channelName, channelName, channelName,
        importance: Importance.max,
        priority: Priority.high,
        sound: RawResourceAndroidNotificationSound('notification'),
        vibrationPattern: vibration ? vibrationPattern : null,
        enableVibration: vibration);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: iOSPlatformChannelSpecifics);

    try {
      await plugin.show(0, title, msg, notificationDetails);
    } catch (ex) {
      print(ex);
    }
  }
Future<NotificationAppLaunchDetails> notificationAppLaunchDetails()async{
    await initialize_notification();
  final NotificationAppLaunchDetails notificationAppLaunchDetails =
      await plugin.getNotificationAppLaunchDetails();
    return notificationAppLaunchDetails;
}

}