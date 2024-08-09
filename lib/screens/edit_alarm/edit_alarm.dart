import 'package:clockee/constants/theme_data.dart';
import 'package:clockee/widgets/simple_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:clockee/widgets/dialog_container/dialog_container.dart';
import 'package:clockee/screens/edit_alarm/components/edit_alarm_days.dart';
import 'package:clockee/screens/edit_alarm/components/edit_alarm_head.dart';
import 'package:clockee/screens/edit_alarm/components/edit_alarm_music.dart';
import 'package:clockee/screens/edit_alarm/components/edit_alarm_slider.dart';
import 'package:clockee/screens/edit_alarm/components/edit_alarm_time.dart';
import 'package:clockee/services/alarm_list_manager.dart';
import 'package:clockee/services/alarm_scheduler.dart';
import 'package:clockee/utils/widget_helper.dart';
import 'package:clockee/stores/observable_alarm/observable_alarm.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants/assets.dart';
import '../../widgets/widgets.dart';

class EditAlarm extends StatelessWidget {
  final ObservableAlarm? alarm;
  final AlarmListManager? manager;

  EditAlarm({this.alarm, this.manager});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print('onWillPop $alarm');
        await manager!.saveAlarm(alarm!);
        await AlarmScheduler().scheduleAlarm(alarm!);
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: [
            Container(

              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(gradient: CustomColors.primaryGradient),
              padding: EdgeInsets.only(left: 15, right: 15, top: 50, bottom: 0),
              child: SingleChildScrollView(
                child: Column(children: [
                  Center(
                    child: Text(
                      "Set Alarm",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w900,
                          color: Colors.white),
                    ),
                  ),
                  Widgets.heightSpaceH3,

                  Center(child: Icon(Icons.alarm,color: Colors.white,size: 80,)),
                  // Center(
                  //     child: SvgPicture.asset(
                  //       Assets.moonIcon,
                  //       height: .25.sh,
                  //     )),
                  Observer(
                    builder: (context) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[   Widgets.heightSpaceH1,
                        EditAlarmTime(alarm: this.alarm!),   Widgets.heightSpaceH3,
                        EditAlarmHead(alarm: this.alarm!),
                        Divider(color: Colors.purple,),
                        Widgets.heightSpaceH2,
                        Text('Repeat', style: TextStyle(fontSize: 15,color: Colors.white70)),
                        EditAlarmDays(alarm: this.alarm!),
                        Widgets.heightSpaceH1,
                        Divider(color: Colors.purple,), Widgets.heightSpaceH2,
                        // SizedBox(
                        //   height: 10,
                        // ),
                        // EditAlarmMusic(alarm: this.alarm!),
                        // Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Alarm Sound', style: TextStyle(fontSize: 15,color: Colors.white70)),

                            Row(
                              children: [
                                Text('Select sound  ', style: TextStyle(fontSize: 11,color: Colors.white)),
                                Icon(Icons.arrow_forward_ios,size: 14,color: Colors.white,)
                              ],
                            ),
                          ],
                        ),

                        Widgets.heightSpaceH1,    Row(children: [
                          Icon(
                           alarm!.volume! > 0
                                ? Icons.volume_up_outlined
                                : Icons.volume_off_outlined,
                            size: 25,
                            color: alarm!.volume! > 0
                                ? Colors.white
                                : Colors.white54,
                          ),
                          Expanded(
                              child: Slider(activeColor: Colors.purpleAccent,thumbColor: Colors.white,
                                value: alarm!.volume!,inactiveColor: Colors.white54,
                                min: 0,
                                max: 1,

                                onChanged: (newVolume) =>
                              alarm!.volume = newVolume,
                              ))
                        ]),
                          // EditAlarmSlider(alarm: this.alarm!),
                        Widgets.heightSpaceH1,
                        Divider(color: Colors.purple,)

                      ],
                    ),
                  ),
                ]),
              ),
            ),
            Positioned(
                left: 15,
                top: 50,
                child: InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white70,
                  ),
                )),
            Positioned(
                right: 15,
                top: 55,
                child: InkWell(
                  onTap: ()  async{
                    await manager!.saveAlarm(alarm!);
                    await AlarmScheduler().scheduleAlarm(alarm!);
                    Navigator.pop(context);
                  },
                  child:  Text('Done', style: TextStyle(fontSize: 15,color: Colors.white70)),
                ))
          ],
        ),
      ),
    );
  }
}
