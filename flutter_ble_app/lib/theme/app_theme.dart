import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData appTheme = ThemeData(
  scaffoldBackgroundColor: colorBackground,
  appBarTheme: AppBarTheme(
    backgroundColor: colorBackground,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: colorBackground,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: colorBackground,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  ),
);

Color? colorCard = Colors.grey[200];
Color? colorBackground = Colors.grey[300];
