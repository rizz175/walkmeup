import 'package:clockee/constants/theme_data.dart';
import 'package:clockee/utils/widget_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:clockee/stores/observable_alarm/observable_alarm.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class EditAlarmSlider extends StatefulWidget {
  final ObservableAlarm? alarm;

  const EditAlarmSlider({Key? key, this.alarm}) : super(key: key);

  @override
  _EditAlarmSliderState createState() => _EditAlarmSliderState();
}

class _EditAlarmSliderState extends State<EditAlarmSlider> {
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) => Padding(
          padding: EdgeInsets.all(10),
          child: Neumorphic(
            style: NeumorphicStyle(
              color: Colors.white.withOpacity(0.4),
              depth: 2,
              intensity: 9,
            ),
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Column(
                children: [
                  Row(children: [
                    Icon(
                      Icons.trending_up_outlined,
                      size: 25,
                      color: CustomColors.sdPrimaryColor,
                    ),
                    text("Progressive Volume", fontSize: 14.0),
                    Switch(
                      value: widget.alarm!.progressiveVolume!,
                      onChanged: (value) {
                        widget.alarm!.progressiveVolume =
                            !widget.alarm!.progressiveVolume!;
                      },
                      activeTrackColor: Colors.green,
                      inactiveTrackColor: CustomColors.sdShadowDarkColor,
                    ),
                  ]),

                ],
              ),
            ),
          )),
    );
  }
}
