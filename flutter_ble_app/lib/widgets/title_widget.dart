import 'package:flutter/material.dart';
import 'package:flutter_ble_app/consts/consts.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget({
    super.key,
    required this.title,
    required this.isTitle,
  });

  final String title;
  final bool isTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: hPadding),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: isTitle ? titleSize : subTitleSize,
          color: Colors.grey[800],
        ),
      ),
    );
  }
}
