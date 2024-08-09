import 'package:clockee/constants/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:clockee/stores/observable_alarm/observable_alarm.dart';

class EditAlarmTime extends StatelessWidget {
  final ObservableAlarm alarm;

  const EditAlarmTime({Key? key, required this.alarm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        child: Observer(builder: (context) {
          final hours = alarm.hour.toString().padLeft(2, '0');
          final minutes = alarm.minute.toString().padLeft(2, '0');
          return  Row(
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
          );

        }),
        onTap: () async {
          final time = await showTimePicker(
              context: context,
              initialTime: TimeOfDay(hour: alarm.hour!, minute: alarm.minute!));
          if (time != null) {
            alarm.hour = time.hour;
            alarm.minute = time.minute;
          }
        },
      ),
    );
  }
}
