// pedometer_provider.dart
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

// class PedometerProvider with ChangeNotifier {
//   int _steps = 0;
//   final int _requiredSteps = 5;
//   String _status = 'Unknown';
//
//   int get steps => _steps;
//   int get requiredSteps => _requiredSteps;
//   String get status => _status;
//
//   PedometerProvider() {
//     _initPedometer();
//   }
//
//   Future<void> _initPedometer() async {
//     bool granted = await _checkActivityRecognitionPermission();
//     if (!granted) {
//       _status = 'Activity recognition permission not granted.';
//       notifyListeners();
//       return;
//     }
//
//     // Initialize Pedometer streams
//     Pedometer.stepCountStream.listen((event) {
//       _steps = event.steps;
//       notifyListeners();
//     }).onError((error) {
//       _status = 'Step Count Error: $error';
//       notifyListeners();
//     });
//
//     Pedometer.pedestrianStatusStream.listen((event) {
//       _status = event.status;
//       notifyListeners();
//     }).onError((error) {
//       _status = 'Pedestrian Status Error: $error';
//       notifyListeners();
//     });
//   }
//
//   Future<bool> _checkActivityRecognitionPermission() async {
//     bool granted = await Permission.activityRecognition.isGranted;
//
//     if (!granted) {
//       granted = await Permission.activityRecognition.request() ==
//           PermissionStatus.granted;
//     }
//
//     return granted;
//   }
// }

class PedometerProvider extends ChangeNotifier {
  static const int minDecrement = 5;
  static const int sensorDelay = 200; // in milliseconds
  static const int sensorDelayOnShake = 1000; // in milliseconds
  static const double noise = 0.3;
  static const double defaultMaxDelta = 7.0;

   int? maxSteps;
  int stepCount = 0;
  double? maxDelta;
  double? minAccel;
  double? maxAccel;

  int cheatCount = 0;
  int? maxCheat;
  int? cheatDecrement;
  int decrementCount = 0;

  double accel = 0.0;
  double accelCurrent = 9.8; // Gravity
  double accelLast = 9.8;
  double lastX = 0.0;
  double lastY = 0.0;
  double lastZ = 0.0;

  Timer? _sensorTimer;
  DateTime timeLast = DateTime.now();

  PedometerProvider({
    required this.maxSteps,
    this.maxDelta = defaultMaxDelta,
    this.minAccel = 1.2,
    this.maxAccel = 5.5,
    this.maxCheat = 4,
  }) {
    cheatDecrement = (maxCheat! ~/ 2);
    _setupSensor();
  }

  void _setupSensor() {
    _sensorTimer = Timer.periodic(Duration(milliseconds: sensorDelay), (timer) {
      // Check sensor data here
    });

    // Listen to accelerometer events
    Sensors().accelerometerEventStream().listen((AccelerometerEvent event) {
      _onSensorChanged(event);
    });
  }

  void _onSensorChanged(AccelerometerEvent event) {
    double x = event.x;
    double y = event.y;
    double z = event.z;

    accelLast = accelCurrent;
    accelCurrent = sqrt(x * x + y * y + z * z); // Use sqrt function from dart:math

    double delta = accelCurrent - accelLast;
    accel = accel * 0.9 + delta; // Low-pass filter
    DateTime timeCurrent = DateTime.now();

    double deltaX = (lastX - x).abs();
    double deltaY = (lastY - y).abs();
    double deltaZ = (lastZ - z).abs();

    if (deltaX < noise) deltaX = 0.0;
    if (deltaY < noise) deltaY = 0.0;
    if (deltaZ < noise) deltaZ = 0.0;

    lastX = x;
    lastY = y;
    lastZ = z;

    bool isMaxDelta = deltaX > maxDelta! || deltaY > maxDelta! || deltaZ > maxDelta!;

    if (timeCurrent.difference(timeLast).inMilliseconds > sensorDelay) {
      timeLast = timeCurrent;
      if (accel > minAccel! && accel <= maxAccel!) {
        if (isMaxDelta) {
          cheatCount -= cheatDecrement!;
          if (cheatCount < 0) cheatCount = 0;
        }
        _takeStep();
      }
    }
    if (isMaxDelta || accel > maxAccel!) {
      cheatCount++;
      if (_isCheatThresholdHit()) {
        _onShakeDetected(timeCurrent);
      }
    }
  }

  void _takeStep() {
    stepCount++;
    if (stepCount > maxSteps!) {
      stepCount = maxSteps!;
    }
    notifyListeners();
  }

  void _onShakeDetected(DateTime timeCurrent) {
    timeLast = timeCurrent.add(Duration(milliseconds: sensorDelayOnShake));
    int decrement = _getDecrement();
    if (stepCount - decrement < 0) {
      decrement = stepCount;
    }

    stepCount -= decrement;
    decrementCount++;
    cheatCount = 0;

    notifyListeners();
  }

  int _getDecrement() {
    int halfDecrement = maxSteps! ~/ 2;
    return halfDecrement > minDecrement ? halfDecrement : minDecrement;
  }

  bool _isCheatThresholdHit() {
    return cheatCount == maxCheat;
  }

  int getRemainingSteps() {
    return maxSteps! - stepCount;
  }

  bool isStepsComplete() {
    return stepCount >= maxSteps!;
  }

  int getProgress() {
    return (stepCount / maxSteps! * 100).toInt();
  }

  @override
  void dispose() {
    _sensorTimer?.cancel();
    super.dispose();
  }
}
