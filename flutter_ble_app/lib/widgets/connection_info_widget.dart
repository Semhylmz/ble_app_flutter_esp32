import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ble_app/consts/consts.dart';
import 'package:flutter_ble_app/theme/app_theme.dart';

class ConnectionInfoWidget extends StatelessWidget {
  const ConnectionInfoWidget({
    super.key,
    required this.changeStatus,
    required this.infoText,
    required this.isConnected,
  });

  final Function(bool) changeStatus;
  final String infoText;
  final bool isConnected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: hPadding, vertical: vPadding),
      child: Container(
        decoration: BoxDecoration(
          color: colorCard,
          borderRadius: BorderRadius.circular(24.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 25.0),
        child: ListTile(
          leading: Icon(
            isConnected
                ? Icons.bluetooth_connected_outlined
                : Icons.bluetooth_outlined,
            size: iconSize,
            color: isConnected ? CupertinoColors.systemBlue : Colors.black,
          ),
          title: Text(
            infoText,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: const TextStyle(
              fontSize: infoTextSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: CupertinoSwitch(
            activeColor: CupertinoColors.systemBlue,
            value: isConnected ? true : false,
            onChanged: (value) async {
              changeStatus.call(value);
            },
          ),
        ),
      ),
    );
  }
}
