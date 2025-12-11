import 'package:flutter/material.dart';
import 'custom_themes/appbar_theme.dart';
import 'custom_themes/bottom_sheet_theme.dart';
import 'custom_themes/checkbox_theme.dart';
import 'custom_themes/chip_theme.dart';
import 'custom_themes/elevated_button_theme.dart';
import 'custom_themes/outlined_button_theme.dart';
import 'custom_themes/text_field_theme.dart';
import 'custom_themes/text_theme.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Satoshi',
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    textTheme: EcommerceTextTheme.lightTextTheme,
    chipTheme: EcommerceChipTheme.lightChipTheme,
    appBarTheme: EcommerceAppBarTheme.lightAppBarTheme,
    checkboxTheme: EcommerceCheckBoxTheme.lightCheckboxTheme,
    bottomSheetTheme: EcommerceBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: EcommerceElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: EcommerceOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: EcommerceTextFormFieldTheme.lightInputDecorationTheme,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Satoshi',
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.black,
    textTheme: EcommerceTextTheme.darkTextTheme,
    chipTheme: EcommerceChipTheme.darkChipTheme,
    appBarTheme: EcommerceAppBarTheme.darkAppBarTheme,
    checkboxTheme: EcommerceCheckBoxTheme.darkCheckboxTheme,
    bottomSheetTheme: EcommerceBottomSheetTheme.darkBottomSheetTheme,
    elevatedButtonTheme: EcommerceElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: EcommerceOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: EcommerceTextFormFieldTheme.darkInputDecorationTheme,
  );
}
