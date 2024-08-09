import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/theme_data.dart';
import '../../widgets/widgets.dart';

class SettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(gradient: CustomColors.primaryGradient),
              padding: EdgeInsets.only(left: 15, right: 15, top: 50, bottom: 0),
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          "Settings",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w900,
                              color: Colors.white),
                        ),
                      ),
                      Widgets.heightSpaceH3,
                      stepsCounterSection(),
                      Widgets.heightSpaceH2,
                      alarmSection(),
                    ]),
              )),
          Positioned(
              left: 15,
              top: 50,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white70,
                ),
              )),
        ],
      ),
    );
  }

  stepsCounterSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Step Counter  ',
            style: TextStyle(fontSize: 11, color: Colors.red)),
        Widgets.heightSpaceH3,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('No of Steps',
                    style: TextStyle(fontSize: 16, color: Colors.white70)),
                Widgets.heightSpaceH1,
                Text('15', style: TextStyle(fontSize: 18, color: Colors.white)),
              ],
            ),
            Icon(
              Icons.keyboard_arrow_down,
              size: 20,
              color: Colors.white,
            ),
          ],
        ),
        Widgets.heightSpaceH1,
        Divider(
          color: Colors.purple,
        ),
        Widgets.heightSpaceH1,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Step Sensitivity',
                    style: TextStyle(fontSize: 16, color: Colors.white70)),
                Widgets.heightSpaceH1,
                Text('UltraHigh',
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ],
            ),
            Icon(
              Icons.keyboard_arrow_down,
              size: 20,
              color: Colors.white,
            ),
          ],
        ),
        Widgets.heightSpaceH1,
        Divider(
          color: Colors.purple,
        ),
        Widgets.heightSpaceH1,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Shake Sensitivity',
                    style: TextStyle(fontSize: 16, color: Colors.white70)),
                Widgets.heightSpaceH1,
                Text('Medium',
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ],
            ),
            Icon(
              Icons.keyboard_arrow_down,
              size: 20,
              color: Colors.white,
            ),
          ],
        ),
        Widgets.heightSpaceH1,
        Divider(
          color: Colors.purple,
        ),
        Widgets.heightSpaceH1,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Voice Assistance',
                    style: TextStyle(fontSize: 16, color: Colors.white70)),
                Widgets.heightSpaceH1,
                SizedBox(
                  width: .65.sw,
                  child: Text(
                    'Enable voice feedback for steps',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                    maxLines: 2,
                  ),
                ),
              ],
            ),
            Observer(
              builder: (context) => CupertinoSwitch(
                value: true,
                activeColor: Colors.purpleAccent,
                onChanged: (value) {
                  //
                },
              ),
            ),
          ],
        ),
        Widgets.heightSpaceH1,
        Divider(
          color: Colors.purple,
        ),
      ],
    );
  }

  alarmSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Alarms  ', style: TextStyle(fontSize: 11, color: Colors.red)),
        Widgets.heightSpaceH3,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Evil Mode',
                    style: TextStyle(fontSize: 16, color: Colors.white70)),
                Widgets.heightSpaceH1,
                SizedBox(
                  width: .65.sw,
                  child: Text(
                    'Disable the snooze button',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                    maxLines: 2,
                  ),
                ),
              ],
            ),
            Observer(
              builder: (context) => CupertinoSwitch(
                value: true,
                activeColor: Colors.purpleAccent,
                onChanged: (value) {
                  //
                },
              ),
            ),
          ],
        ),
        Widgets.heightSpaceH1,
        Divider(
          color: Colors.purple,
        ),
        Widgets.heightSpaceH1,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Silence After',
                    style: TextStyle(fontSize: 16, color: Colors.white70)),
                Widgets.heightSpaceH1,
                Text('10 minutes',
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ],
            ),
            Icon(
              Icons.keyboard_arrow_down,
              size: 20,
              color: Colors.white,
            ),
          ],
        ),
        Widgets.heightSpaceH1,
        Divider(
          color: Colors.purple,
        ),
        Widgets.heightSpaceH1,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Snooze Length',
                    style: TextStyle(fontSize: 16, color: Colors.white70)),
                Widgets.heightSpaceH1,
                Text('10 minutes',
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ],
            ),
            Icon(
              Icons.keyboard_arrow_down,
              size: 20,
              color: Colors.white,
            ),
          ],
        ),
        Widgets.heightSpaceH1,
        Divider(
          color: Colors.purple,
        ),
        Widgets.heightSpaceH1,
        Widgets.heightSpaceH1,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Alarm Volume',
                    style: TextStyle(fontSize: 16, color: Colors.white70)),
                Widgets.heightSpaceH1,
                Text('Set volume',
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ],
            ),
            Icon(
              Icons.keyboard_arrow_down,
              size: 20,
              color: Colors.white,
            ),
          ],
        ),
        Widgets.heightSpaceH1,
        Divider(
          color: Colors.purple,
        ),
        Widgets.heightSpaceH1,
      ],
    );
  }
}
