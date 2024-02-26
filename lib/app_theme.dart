import 'package:flutter/material.dart';

import 'helpers/fonts_helper.dart';

class AppTheme {
  static const double globalElevation = 0;
  static const primaryColor = Color(0xFFF37733);
  static const secundaryColor = Color(0xFF54585A);
  static const primaryColorTxt = Color.fromARGB(100, 0, 0, 0);
  static const secundaryColorTxt = Color.fromARGB(43, 0, 0, 0);
  static const inputFillColor = Color.fromRGBO(242, 242, 242, 1);
  static const inputBorderFillColor = Color(0xFF9FA1A4);
  static const inputFontColor = Color.fromARGB(43, 0, 0, 0);
  static const inputLabelColor = Color.fromARGB(255, 0, 0, 0);

  static const Color primaryColorButtons = Color(0xFFF37733);

  static const TextStyle titles = TextStyle(
      fontSize: 30,
      color: primaryColor,
      fontFamily: FontsHelper.RobotoRegular,
      fontWeight: FontWeight.w700);
  static const TextStyle bConnect = TextStyle(
      fontSize: 30,
      color: Color(0xFF9FA1A4),
      fontFamily: FontsHelper.RobotoBold);
  static const TextStyle primaryColorAppBarTitle = TextStyle(
      fontSize: 20,
      color: primaryColor,
      fontFamily: FontsHelper.RobotoBold,
      fontWeight: FontWeight.bold);
  static const TextStyle subtitles = TextStyle(
      fontSize: 15, color: primaryColorTxt, fontFamily: FontsHelper.RobotoBold);
  static const TextStyle labelInputText = TextStyle(
      fontSize: 15,
      color: secundaryColorTxt,
      fontFamily: FontsHelper.RobotoRegular,
      fontWeight: FontWeight.w400);
  static const TextStyle copyRight = TextStyle(
      fontSize: 11,
      color: secundaryColorTxt,
      fontFamily: FontsHelper.RobotoBold,
      fontWeight: FontWeight.w400);
  static const TextStyle waterTitle = TextStyle(
      fontSize: 17,
      color: secundaryColor,
      fontFamily: FontsHelper.RobotoBold,
      fontWeight: FontWeight.w400);
  static const TextStyle waterSubTitle = TextStyle(
      fontSize: 25,
      color: Colors.black,
      fontFamily: FontsHelper.RobotoBold,
      fontWeight: FontWeight.w700);
  static const TextStyle waterSubTitleSmall = TextStyle(
      fontSize: 16,
      color: Colors.black,
      fontFamily: FontsHelper.RobotoBold,
      fontWeight: FontWeight.w700);
  static ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: primaryColor,
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      elevation: globalElevation,
      backgroundColor: Colors.white,
      titleTextStyle: primaryColorAppBarTitle,
      iconTheme: IconThemeData(
        size: 28,
        color: primaryColorButtons, //change your color here
      ),
    ),
    listTileTheme: const ListTileThemeData(
      iconColor: primaryColor,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColorButtons),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(backgroundColor: secundaryColor)),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shadowColor: primaryColorButtons.withOpacity(.6),
        elevation: 4,
        backgroundColor: primaryColorButtons,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      fillColor: Color.fromARGB(100, 232, 232, 232),
      hintStyle: TextStyle(fontSize: 18, color: inputFontColor),
      floatingLabelStyle: TextStyle(
          color: inputLabelColor, fontSize: 18, fontWeight: FontWeight.bold),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      labelStyle: TextStyle(
          color: inputLabelColor, fontSize: 18, fontWeight: FontWeight.bold),
      iconColor: inputFontColor,
      prefixIconColor: inputFontColor,
      suffixIconColor: inputFontColor,
      focusColor: inputFontColor,
    ),
  );
}
