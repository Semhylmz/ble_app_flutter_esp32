import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ble_app/consts/consts.dart';
import 'package:flutter_ble_app/theme/app_theme.dart';
import 'package:flutter_ble_app/widgets/title_widget.dart';

class LedStatusWidget extends StatelessWidget {
  const LedStatusWidget({
    super.key,
    required this.changeStatus,
    required this.isLedOn,
  });

  final Function(bool) changeStatus;
  final bool isLedOn;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleWidget(title: 'Led Status', isTitle: false),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: hPadding, vertical: vPadding),
          child: Container(
            decoration: BoxDecoration(
              color: colorCard,
              borderRadius: BorderRadius.circular(24.0),
            ),
            padding: const EdgeInsets.symmetric(vertical: 25.0),
            child: ListTile(
              leading: Icon(isLedOn ? Icons.lightbulb : Icons.lightbulb_outline,
                  size: iconSize,
                  color: isLedOn ? CupertinoColors.systemYellow : Colors.black),
              title: Text(
                isLedOn ? 'On' : 'Off',
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: const TextStyle(
                  fontSize: infoTextSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: CupertinoSwitch(
                activeColor: CupertinoColors.systemYellow,
                value: isLedOn,
                onChanged: (value) {
                  changeStatus.call(value);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
