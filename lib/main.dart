import 'dart:async';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:clockee/screens/main/alarm_list_screen.dart';
import 'package:clockee/services/pedometer_service.dart';
import 'package:clockee/stores/observable_alarm/observable_alarm.dart';
import 'package:clockee/screens/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'constants/theme_data.dart';
import 'enums.dart';
import 'models/menu_info.dart';
import 'screens/alarm_screen/alarm_screen.dart';
import 'services/alarm_polling_worker.dart';
import 'services/file_proxy.dart';
import 'services/life_cycle_listener.dart';
import 'services/media_handler.dart';
import 'stores/alarm_list/alarm_list.dart';
import 'stores/alarm_status/alarm_status.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wakelock/wakelock.dart';
import 'utils/schedule_notifications.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

AlarmList list = AlarmList();
MediaHandler mediaHandler = MediaHandler();
var playingSoundPath = ValueNotifier<String>("");
NotificationAppLaunchDetails? notificationAppLaunchDetails;
ScheduleNotifications notifications = ScheduleNotifications(
    'clockee_notification',
    'Clockee Alarm Notication',
    'Alerts on scheduled alarm events',
    appIcon: 'notification_logo');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final alarms = await new JsonFileStorage().readList();
  list.setAlarms(alarms);
  list.alarms.forEach((alarm) {
    alarm.loadTracks();
  });
  WidgetsBinding.instance!.addObserver(LifeCycleListener(list));

  await AndroidAlarmManager.initialize();

  runApp(MyApp());

  AlarmPollingWorker().createPollingWorker();

  final externalPath = await getExternalStorageDirectory();
  print(externalPath!.path);
  if (!externalPath.existsSync()) externalPath.create(recursive: true);
}

void restartApp() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {checkAndroidScheduleExactAlarmPermission();
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                  create: (_) =>
                      PedometerProvider(maxSteps: 15)), // Initialize the provider here
              // other providers
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Walk Me Up',
              home: Observer(builder: (context) {
                AlarmStatus status = AlarmStatus();
                print('status.isAlarm ${status.isAlarm}');
                print('list.alarms.length ${list.alarms.length}');
                if (status.isAlarm) {
                  final id = status.alarmId;
                  final alarm = list.alarms.firstWhere(
                      (alarm) => alarm.id == id,
                      orElse: () => ObservableAlarm());

                   mediaHandler.playMusic(alarm);
                  Wakelock.enable();

                  return Scaffold(body: AlarmView(alarm: alarm));
                }
                return ChangeNotifierProvider<MenuInfo>(
                    create: (context) =>
                        MenuInfo(MenuType.clock, icon: Icons.timelapse),
                    child: AlarmListScreen(alarms: list,
                    ));
              }),
            ),
          );
        });
  }

  Future<void> checkAndroidScheduleExactAlarmPermission() async {
    final status = await Permission.scheduleExactAlarm.status;
    print('Schedule exact alarm permission: $status.');
    if (status.isDenied) {
      print('Requesting schedule exact alarm permission...');
      final res = await Permission.scheduleExactAlarm.request();
      print('Schedule exact alarm permission ${res.isGranted ? '' : 'not'} granted.');
    }
  }
}
