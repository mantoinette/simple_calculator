import 'dart:async';
import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BatteryService {
  BatteryService._();

  static final BatteryService instance = BatteryService._();

  final Battery _battery = Battery();
  late StreamSubscription<BatteryState> _batteryStateSubscription;

  void initialize() {
    _batteryStateSubscription = _battery.onBatteryStateChanged.listen((BatteryState state) async {
      if (state == BatteryState.charging) {
        int batteryLevel = await _battery.batteryLevel;
        if (batteryLevel >= 90) {
          Fluttertoast.showToast(
            msg: "Battery level is at $batteryLevel%",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      }
    });
  }

  void dispose() {
    _batteryStateSubscription.cancel();
  }
}
