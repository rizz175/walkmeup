import 'dart:math';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:clockee/constants/assets.dart';
import 'package:clockee/constants/theme_data.dart';
import 'package:clockee/services/alarm_scheduler.dart';
import 'package:clockee/utils/widget_helper.dart';
import 'package:clockee/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:clockee/stores/alarm_status/alarm_status.dart';
import 'package:clockee/stores/observable_alarm/observable_alarm.dart';
import 'package:clockee/widgets/rounded_button.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:wakelock/wakelock.dart';

import '../../main.dart';
import '../../services/pedometer_service.dart';

class AlarmView extends StatelessWidget {
  final ObservableAlarm? alarm;

  const AlarmView({Key? key, required this.alarm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final hours =
        now.hour.toString().padLeft(2, '0'); // Format hours as 2 digits
    final minutes =
        now.minute.toString().padLeft(2, '0'); // Format minutes as 2 digits

    return Scaffold(
      body: Consumer<PedometerProvider>(
          builder: (context, pedometerProvider, child) {
        int steps = pedometerProvider.stepCount;
        int requiredSteps = pedometerProvider
            .getRemainingSteps(); // Example value; adjust as necessary
int stepAre=steps;

        if(stepAre==15){
  dismissCurrentAlarm();
}
        return Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(gradient: CustomColors.primaryGradient),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Widgets.heightSpaceH5,
                    SvgPicture.asset(
                      Assets.moonIcon,
                      height: .25.sh,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          hours,
                          style: TextStyle(
                              fontSize: 55,
                              fontWeight: FontWeight.w900,
                              color: Colors.white),
                        ),
                        Text(
                          " Hr",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          minutes,
                          style: TextStyle(
                              fontSize: 55,
                              fontWeight: FontWeight.w900,
                              color: Colors.white),
                        ),
                        Text(
                          " Min",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    Widgets.heightSpaceH1,
                    Text(
                      "Wake up",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.white70),
                    ),
                    SfRadialGauge(axes: <RadialAxis>[
                      RadialAxis(
                          showTicks: false, // Hide axis ticks
                          axisLineStyle: AxisLineStyle(
                            color: Colors
                                .white70, // Default color of the gauge circle
                            thickness: 0.1, // Thickness of the circle
                            thicknessUnit: GaugeSizeUnit.factor,
                          ),
                          radiusFactor: .65,
                          minimum: 0,
                          maximum: 15,
                          showLabels: false,
                          pointers: <GaugePointer>[
                            RangePointer(
                              color: Colors.purpleAccent,
                              value: steps.toDouble(),
                              cornerStyle: CornerStyle.bothCurve,
                              width: 0.1,
                              sizeUnit: GaugeSizeUnit.factor,
                            )
                          ],
                          annotations: <GaugeAnnotation>[
                            GaugeAnnotation(
                                positionFactor: 1,
                                angle: 90,
                                widget: Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        "Step",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white),
                                      ),
                                      Widgets.heightSpaceH1,
                                      Text(
                                        stepAre<16?"$stepAre/15":"0/15",
                                        style: TextStyle(
                                            fontSize: 50,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white),
                                      ),
                                      Widgets.heightSpaceH1,
                                      Text(
                                        "to go",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ))
                          ])
                    ]),


                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              left: 25,
              right: 25,
              child: GestureDetector(
                onTap: () async {
                  await rescheduleAlarm(10);
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.snooze_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                      text("  Snooze", textColor: Colors.white),
                    ],
                  ),
                ),
              ),
            )
          ],
        );
      }),
    );
  }

  Future<void> rescheduleAlarm(int minutes) async {
    Fluttertoast.showToast(
        msg: "Snooze set to 10 mins",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0
    );
    var checkedDay = DateTime.now();
    var targetDateTime = DateTime(checkedDay.year, checkedDay.month,
        checkedDay.day, alarm!.hour!, alarm!.minute!);
    await AlarmScheduler()
        .newShot(targetDateTime.add(Duration(minutes: minutes)), alarm!.id!);
    dismissCurrentAlarm();

  }

  Future<void> dismissCurrentAlarm() async {

    Wakelock.disable();
    mediaHandler.stopMusic();

    AlarmStatus().isAlarm = false;
    AlarmStatus().alarmId = -1;
    SystemNavigator.pop();
  }
}
