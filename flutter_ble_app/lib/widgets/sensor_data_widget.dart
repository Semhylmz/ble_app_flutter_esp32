import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ble_app/consts/consts.dart';
import 'package:flutter_ble_app/theme/app_theme.dart';
import 'package:gap/gap.dart';

class SensorDataWidget extends StatelessWidget {
  const SensorDataWidget({
    super.key,
    required this.title,
    required this.info,
    required this.iconData,
    required this.color,
  });

  final String title;
  final String info;
  final IconData iconData;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: hPadding,
            vertical: vPadding,
          ),
          child: Container(
            width: double.maxFinite,
            height: 150,
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorCard,
              borderRadius: const BorderRadius.all(
                Radius.circular(22),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(iconData, size: iconSize, color: color),
                const Gap(vPadding * 0.5),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: infoTextSize,
                  ),
                ),
                Text(
                  info,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: titleSize,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
