import 'package:foreground_service/foreground_service.dart';

import '../main.dart';

class Background_Services{

  Future<void> toggleForegroundServiceOnOff(context) async {
    final fgsIsRunning = await ForegroundService.foregroundServiceIsStarted();
    if (fgsIsRunning) {
      await ForegroundService.stopForegroundService();
    } else {
      maybeStartFGS();
    }
  }

}