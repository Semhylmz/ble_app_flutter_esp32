import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ble_app/consts/consts.dart';
import 'package:flutter_ble_app/model/data_model.dart';
import 'package:flutter_ble_app/views/scan_view.dart';
import 'package:flutter_ble_app/widgets/connection_info_widget.dart';
import 'package:flutter_ble_app/widgets/title_widget.dart';
import 'package:flutter_ble_app/widgets/led_status_button.dart';
import 'package:flutter_ble_app/widgets/sensor_data_widget.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.dhtCharacteristic,
  });

  final BluetoothCharacteristic dhtCharacteristic;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ReceivedDataModel _dataModel;
  late BluetoothCharacteristic _dhtCharacteristic;

  @override
  void initState() {
    _dhtCharacteristic = widget.dhtCharacteristic;
    _dataModel = ReceivedDataModel(
      ledStatus: 0,
      temperature: 0.0,
      humidity: 0,
    );
    _listenBleData();
    super.initState();
  }

  @override
  void dispose() {
    if (_dhtCharacteristic.device.isConnected) {
      _dhtCharacteristic.device.disconnect();
    }
    super.dispose();
  }

  Future _sendBleData(SendDataModel dataModel) async {
    if (_dhtCharacteristic.device.isConnected) {
      await _dhtCharacteristic
          .write(utf8.encode(jsonEncode(dataModel.toJson())));
    }
  }

  void _listenBleData() async {
    await _dhtCharacteristic.setNotifyValue(true);
    _dhtCharacteristic.lastValueStream.listen(
          (value) {
        if (mounted) {
          setState(() {
            var decode = utf8.decode(value);
            _dataModel = ReceivedDataModel.fromJson(jsonDecode(decode));
          });
        }
      },
    ).onError((err) {
      if (kDebugMode) print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: [
          const Gap(homeSizedHeight),
          const TitleWidget(title: 'BLE App', isTitle: true),
          const Gap(homeSizedHeight),
          const TitleWidget(title: 'Connection Status', isTitle: false),
          ConnectionInfoWidget(
            isConnected: _dhtCharacteristic.device.isConnected,
            infoText: _dhtCharacteristic.device.isConnected
                ? 'Connected to ${_dhtCharacteristic.device.platformName}'
                : 'Disconnected',
            changeStatus: (p0) async {
              await _dhtCharacteristic.device.disconnect();
              setState(() {});
              Fluttertoast.showToast(
                msg: '${_dhtCharacteristic.device.platformName} disconnected',
              );
              Future.delayed(const Duration(milliseconds: 1500)).then(
                    (value) => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ScanPage()),
                ),
              );
            },
          ),
          LedStatusWidget(
            changeStatus: (p0) async {
              await _sendBleData(
                SendDataModel(
                  ledStatus: _dataModel.ledStatus == 1 ? '0' : '1',
                ),
              );
            },
            isLedOn: _dataModel.ledStatus == 1 ? true : false,
          ),
          const Gap(vPadding),
          const TitleWidget(title: 'Sensor Data', isTitle: false),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: SensorDataWidget(
                  title: 'Temperature',
                  info: '${_dataModel.temperature.toStringAsFixed(1)}°',
                  iconData: Icons.thermostat_outlined,
                  color: Colors.red,
                ),
              ),
              Expanded(
                child: SensorDataWidget(
                  title: 'Humidity',
                  info: '${_dataModel.humidity}%',
                  iconData: Icons.water_drop_outlined,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}