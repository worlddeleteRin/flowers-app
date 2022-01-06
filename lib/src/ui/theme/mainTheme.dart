
import 'package:flutter/material.dart';

// color palette
  // main colors
Color primaryColor = Colors.black;
  // button colors
Color buttonTextForegroundColor = primaryColor;
Color buttonTextOverlayColor = primaryColor; 
Color buttonElevatedForegroundColor = Colors.white;
Color buttonElevatedBackgroundColor = primaryColor;
  // appBar colors
Color appBarBackgroundColor = Colors.white;
Color appBarForegroundColor = Colors.black;

// eof color palette


// app bar theme 
AppBarTheme appBarTheme = AppBarTheme(
  // color: Colors.black,
  backgroundColor: appBarBackgroundColor, 
  foregroundColor: appBarForegroundColor,
  elevation: 0.0,
);

// text theme
TextTheme textTheme = TextTheme(
);

// text button theme data
TextButtonThemeData textButtonTheme = TextButtonThemeData(
  style: ButtonStyle(
    foregroundColor: MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.pressed)) {
          return buttonTextForegroundColor.withOpacity(0.7);
        }
        return buttonTextForegroundColor;
      }
    ),
    overlayColor: MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.pressed)) {
          return buttonTextForegroundColor.withOpacity(0.1);
        }
        return buttonTextForegroundColor;
      }
    ),
  )
);

// outline button theme
OutlinedButtonThemeData outlineButtonTheme = OutlinedButtonThemeData(
  style: ButtonStyle(
    foregroundColor: MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.pressed)) {
          return buttonTextForegroundColor.withOpacity(0.7);
        }
        return buttonTextForegroundColor;
      }
    ),
  )
);

// elevated button theme data
ElevatedButtonThemeData elevatedButtonTheme = ElevatedButtonThemeData(
  style: ButtonStyle(
    textStyle: MaterialStateProperty.all<TextStyle?>(
      TextStyle(
        fontWeight: FontWeight.w600,
      )
    ),
    foregroundColor: MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.pressed)) {
          return buttonElevatedForegroundColor.withOpacity(0.7);
        }
        return buttonElevatedForegroundColor;
      }
    ),
    backgroundColor: MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.pressed)) {
          return buttonElevatedBackgroundColor.withOpacity(0.7);
        }
        return buttonElevatedBackgroundColor;
      }
    ),
  )
);


ThemeData mainTheme = ThemeData(
    primaryColor: primaryColor,
    textTheme: textTheme, 
    appBarTheme: appBarTheme,
    textButtonTheme: textButtonTheme,
    outlinedButtonTheme: outlineButtonTheme,
    elevatedButtonTheme: elevatedButtonTheme,
);
