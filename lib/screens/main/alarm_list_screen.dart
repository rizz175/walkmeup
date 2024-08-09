import 'package:clockee/constants/theme_data.dart';
import 'package:clockee/screens/settings/settings_view.dart';
import 'package:clockee/widgets/widgets.dart';
// import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobx/mobx.dart';
import 'package:clockee/widgets/alarm_item/alarm_item.dart';
import 'package:clockee/screens/edit_alarm/edit_alarm.dart';
import 'package:clockee/services/alarm_list_manager.dart';
import 'package:clockee/services/alarm_scheduler.dart';
import 'package:clockee/stores/alarm_list/alarm_list.dart';
import 'package:clockee/stores/observable_alarm/observable_alarm.dart';

import '../../constants/assets.dart';

class AlarmListScreen extends StatelessWidget {
  final AlarmList alarms;

  const AlarmListScreen({Key? key, required this.alarms}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AlarmListManager _manager = AlarmListManager(alarms);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: () {
          addAlarm(context, _manager);
        },
        child: Icon(Icons.add),
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(gradient: CustomColors.primaryGradient),
            padding: EdgeInsets.only(left: 15, right: 15, top: 50, bottom: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Text(
                    "Walk Me Up",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                        color: Colors.white),
                  ),
                ),
                Widgets.heightSpaceH1,
                Center(
                    child: SvgPicture.asset(
                  Assets.moonIcon,
                  height: .25.sh,
                )),
                Text(
                  alarms.alarms.length != 0 ? "Alarms" : "",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
                Widgets.heightSpaceH2,
                Flexible(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        alarms.alarms.length != 0
                            ? Observer(
                                builder: (context) => ListView.separated(
                                  padding: EdgeInsets.zero,
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    final alarm = alarms.alarms[index];

                                    return Dismissible(
                                      key: Key(alarm.id.toString()),
                                      child: AlarmItem(
                                          alarm: alarm, manager: _manager),
                                      onDismissed: (_) {
                                        AlarmScheduler().clearAlarm(alarm);
                                        alarms.alarms.removeAt(index);
                                      },
                                    );
                                  },
                                  itemCount: alarms.alarms.length,
                                  separatorBuilder: (context, index) =>
                                      const Divider(),
                                ),
                              )
                            : Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 150),
                                  child: Text("No Alarms",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white70)),
                                ),
                              ),
                        Widgets.heightSpaceH4,
                      ],
                    ),
                  ),
                ),

                // BottomAddButton(
                //   onPressed: () {
                //     },
                // )
              ],
            ),
          ),
          Positioned(
              right: 10,
              top: 50,
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingsView()));
                    },
                    child: Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingsView()));
                    },
                    child: Icon(
                      Icons.settings,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  )
                ],
              ))
        ],
      ),
    );
  }

  void addAlarm(context, _manager) {
    TimeOfDay tod = TimeOfDay.fromDateTime(DateTime.now());
    final newAlarm = ObservableAlarm.dayList(
        alarms.alarms.length,
        'New Alarm',
        tod.hour,
        tod.minute,
        0.7,
        false,
        true,
        List.filled(7, false),
        ObservableList<String>.of([]), <String>[]);
    alarms.alarms.add(newAlarm);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditAlarm(
          alarm: newAlarm,
          manager: _manager,
        ),
      ),
    );
  }
}
