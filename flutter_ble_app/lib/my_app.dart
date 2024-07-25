import 'package:flutter/material.dart';
import 'package:flutter_ble_app/theme/app_theme.dart';
import 'package:flutter_ble_app/views/bluetooth_off_view.dart';
import 'package:flutter_ble_app/views/scan_view.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late BluetoothAdapterState _bluetoothAdapterState;

  @override
  void initState() {
    _bluetoothAdapterState = BluetoothAdapterState.unknown;

    FlutterBluePlus.adapterState.listen((state) {
      setState(() {
        _bluetoothAdapterState = state;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget currentPage = _bluetoothAdapterState != BluetoothAdapterState.on
        ? const BleOffPage()
        : const ScanPage();

    return MaterialApp(
      title: 'Flutter BLE App',
      home: currentPage,
      theme: appTheme,
      debugShowCheckedModeBanner: false,
    );
  }
}