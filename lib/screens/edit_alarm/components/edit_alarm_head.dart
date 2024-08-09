import 'package:clockee/constants/theme_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:clockee/stores/observable_alarm/observable_alarm.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class EditAlarmHead extends StatelessWidget {
  final ObservableAlarm alarm;

  EditAlarmHead({required this.alarm});

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Label', style: TextStyle(fontSize: 15,color: Colors.white70)),
              TextField(
                decoration: InputDecoration(border: InputBorder.none),
                controller: TextEditingController(text: alarm.name),
                style: TextStyle(fontSize: 18,color: Colors.white),
                onChanged: (newName) => alarm.name = newName,
              )
            ],
          ),
        ),SizedBox(width: 50,),
        Observer(
          builder: (context) => CupertinoSwitch(
            value: alarm.active!,activeColor: Colors.purpleAccent,
            onChanged: (value) {
              alarm.active = !alarm.active!;
            },

          ),
        )
      ],
    );
  }
}
