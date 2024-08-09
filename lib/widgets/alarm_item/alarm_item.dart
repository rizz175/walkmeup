import 'package:clockee/constants/theme_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:clockee/screens/edit_alarm/edit_alarm.dart';
import 'package:clockee/services/alarm_list_manager.dart';
import 'package:clockee/stores/alarm_list/alarm_list.dart';
import 'package:clockee/stores/observable_alarm/observable_alarm.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import '../widgets.dart';

const dates = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];

class AlarmItem extends StatelessWidget {
  final ObservableAlarm alarm;
  final AlarmListManager? manager;

  const AlarmItem({Key? key, required this.alarm, this.manager})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  EditAlarm(alarm: this.alarm, manager: manager!))),
      child: Observer(
        builder: (context) =>Container(
          decoration: BoxDecoration(
             borderRadius: BorderRadius.circular(30),
            border: Border.all(color: CustomColors.purpleColor),
            color: Color(0x732d112f)
          ),
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    Text(
                      '${alarm.hour.toString().padLeft(2, '0')}.${alarm.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,letterSpacing: 1,
                          color: Colors.white),
                    ),Widgets.heightSpaceH1,
                    DateRow(alarm: alarm)
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: CupertinoSwitch(
                  activeColor: Colors.purpleAccent,
                  value: alarm.active!,
                  onChanged: (value) {
                    alarm.active = !alarm.active!;
                  },

                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DateRow extends StatelessWidget {
  final ObservableAlarm alarm;
  final List<bool> dayEnabled;

  DateRow({
    Key? key,
    required this.alarm,
  })  : dayEnabled = [
          alarm.monday!,
          alarm.tuesday!,
          alarm.wednesday!,
          alarm.thursday!,
          alarm.friday!,
          alarm.saturday!,
          alarm.sunday!
        ],
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: Size(150, 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: dates.asMap().entries.map((indexStringPair) {
          final dayString = indexStringPair.value;
          final index = indexStringPair.key;
          return Text(
            dayString,
            style: TextStyle(
                color: dayEnabled[index]
                    ?Colors.white.withOpacity(0.5)
                    : Colors.white24,
                fontWeight:
                    dayEnabled[index] ? FontWeight.bold : FontWeight.normal),
          );
        }).toList(),
      ),
    );
  }
}
