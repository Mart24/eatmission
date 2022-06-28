import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_app/Views/constants.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme(bool is0n) {
    themeMode = is0n ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class Mythemes {
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade900,
    colorScheme: ColorScheme.dark(secondary: Color(0xFF84AB5C)),
    primaryColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.white),
    textSelectionTheme: TextSelectionThemeData(
        selectionColor: kPrimaryColor, selectionHandleColor: kPrimaryColor),
    appBarTheme: AppBarTheme(
      color: Colors.blue,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        primary: kPrimaryColor,
      ),
    ),
  );

  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    // colorScheme: ColorScheme.light(secondary: Color(0xFF84AB5C)),
    colorScheme: ColorScheme.light().copyWith(
      primary: kPrimaryColor,
      secondary: kPrimaryColor,
    ),
    primarySwatch: Colors.green,
    primaryColor: Colors.black,
    iconTheme: IconThemeData(color: Colors.white),
    appBarTheme: AppBarTheme(
        color: Colors.blue,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        )),
  );
}
