import 'package:flutter/material.dart';
import 'package:home_rent_app/utils/size_config.dart';

ThemeData lightTheme(BuildContext context) {
  return ThemeData(
    primaryColor: Colors.purpleAccent,
    // scaffoldBackgroundColor: const Color(0xfff2f3f7),
    scaffoldBackgroundColor: Colors.purpleAccent,
    appBarTheme: AppBarTheme(
      elevation: 0,
      color: Colors.purpleAccent,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: SizeConfig.width * 4,
      ),
    ),
    textTheme: const TextTheme(
      headline6: TextStyle(
        color: Colors.black,
        fontFamily: "Open Sans",
        fontWeight: FontWeight.w700,
      ),
      headline5: TextStyle(
        color: Colors.black,
        fontFamily: "Open Sans",
        fontWeight: FontWeight.w700,
      ),
      headline4: TextStyle(
        color: Colors.black,
        fontFamily: "Open Sans",
        fontWeight: FontWeight.w700,
      ),
      bodyText1: TextStyle(
        color: Colors.black,
        fontFamily: "Open Sans",
      ),
      bodyText2: TextStyle(
        color: Colors.black,
        fontFamily: "Open Sans",
      ),
      subtitle1: TextStyle(
        color: Colors.black,
        fontFamily: "Open Sans",
      ),
      subtitle2: TextStyle(
        color: Colors.black,
        fontFamily: "Open Sans",
      ),
      caption: TextStyle(
        color: Colors.black,
        fontFamily: "Open Sans",
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.symmetric(
        vertical: SizeConfig.height * 2.5,
        horizontal: SizeConfig.height * 2,
      ),
      hintStyle: TextStyle(
        fontSize: SizeConfig.width * 3.5,
      ),
      enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.purpleAccent,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(SizeConfig.height * 2),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.purpleAccent,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(SizeConfig.height * 2),
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.red,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(SizeConfig.height * 2),
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.red,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(SizeConfig.height * 2),
                ),
              ),
    ),
  );
}
