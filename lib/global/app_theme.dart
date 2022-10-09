import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants.dart';

enum AppTheme {
  darkMode,
  lightMode,
}

final appThemeData = {
  AppTheme.darkMode: ThemeData(
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
        elevation: 0.0,
        titleTextStyle: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Color(0xFF191919),
        iconTheme: IconThemeData(color: Colors.white, size: 25),
        actionsIconTheme: IconThemeData(color: Colors.white, size: 25)),
    backgroundColor: const Color(0xFF191919),
    brightness: Brightness.dark,
    textTheme: const TextTheme(
        headline2: TextStyle(color: Colors.white),
        headline6: TextStyle(color: Colors.grey)),
    inputDecorationTheme: const InputDecorationTheme(
      hintStyle:
          TextStyle(color: Colors.grey, fontFamily: mainFont, fontSize: 18),
      labelStyle: TextStyle(color: Colors.white),
      border: InputBorder.none,
    ),
    hoverColor: Colors.white.withOpacity(0.1),
    unselectedWidgetColor: const Color(mainColor),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Color(mainColor),
      selectionColor: Color(mainColor),
      selectionHandleColor: Color(mainColor),
    ),
    bottomSheetTheme:
        const BottomSheetThemeData(backgroundColor: Color(cardColor)),
    iconTheme: const IconThemeData(color: Colors.grey),
    dialogBackgroundColor: const Color(cardColor),
  ),
  AppTheme.lightMode: ThemeData(
    scaffoldBackgroundColor: const Color(0xFFF6F8F9),
    appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(
          color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      systemOverlayStyle: SystemUiOverlayStyle.light,
      backgroundColor: Color(0xFFF6F8F9),
      iconTheme: IconThemeData(color: Color(0xFF3F3C36), size: 25),
      actionsIconTheme: IconThemeData(color: Color(0xFF3F3C36), size: 25),
    ),
    brightness: Brightness.light,
    backgroundColor: Colors.white,
    textTheme: TextTheme(
        headline2: const TextStyle(color: Color(0xFF3F3C36)),
        headline6: TextStyle(color: const Color(0xFF3F3C36).withOpacity(0.5))),
    inputDecorationTheme: const InputDecorationTheme(
      hintStyle: TextStyle(color: Colors.grey),
      labelStyle: TextStyle(color: Colors.white),
      border: InputBorder.none,
    ),
    hoverColor: Colors.white.withOpacity(0.1),
    unselectedWidgetColor: const Color(mainColor),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Color(mainColor),
      selectionColor: Color(mainColor),
      selectionHandleColor: Color(mainColor),
    ),
    iconTheme: const IconThemeData(color: Color(0xFF3F3C36)),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Color(0xFFF6F8F9),
    ),
    dialogBackgroundColor: const Color(0xFFF6F8F9),
  ),
};
