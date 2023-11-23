import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../router/custom_transition.dart';

class AppTheme {
  static ThemeData appTheme = ThemeData(
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CustomPageTransitionBuilder(),
        TargetPlatform.iOS: CustomPageTransitionBuilder(),
      },
    ),
    primaryColor: const Color(0xFF000812),
    errorColor: Colors.redAccent,
    canvasColor: Colors.grey,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.fromSwatch(
      accentColor: const Color(0xFF261854),
      errorColor: Colors.red,
    ),
    indicatorColor: const Color(0xFFF6BC18),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 28.h,
    ),
    textTheme: TextTheme(
      headline1: GoogleFonts.roboto(
        fontSize: 93.sp,
        fontWeight: FontWeight.w300,
        letterSpacing: -1.5,
        color: Colors.white,
      ),
      headline2: GoogleFonts.roboto(
        fontSize: 58.sp,
        fontWeight: FontWeight.w300,
        letterSpacing: -0.5,
        color: Colors.white,
      ),
      headline3: GoogleFonts.roboto(
        fontSize: 46.sp,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
      headline4: GoogleFonts.roboto(
        fontSize: 33.sp,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: Colors.white,
      ),
      headline5: GoogleFonts.roboto(
        fontSize: 23.sp,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
      headline6: GoogleFonts.roboto(
        fontSize: 19.sp,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        color: const Color(0xFF000812),
      ),
      subtitle1: GoogleFonts.roboto(
        fontSize: 15.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.15,
        color: const Color(0xFF000812),
      ),
      subtitle2: GoogleFonts.roboto(
        fontSize: 13.sp,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: const Color(0xFF000812),
      ),
      bodyText1: GoogleFonts.openSans(
        color: const Color(0xFF000812),
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
      ),
      bodyText2: GoogleFonts.openSans(
        color: const Color(0xFF000812),
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.25,
      ),
      button: GoogleFonts.roboto(
        color: Colors.white,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.25,
      ),
      caption: GoogleFonts.openSans(
        color: Colors.grey,
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
      ),
      overline: GoogleFonts.openSans(
        color: Colors.grey,
        fontSize: 10.sp,
        fontWeight: FontWeight.w400,
        letterSpacing: 1.5,
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      selectionColor: const Color(0xFF000812).withOpacity(0.4),
      selectionHandleColor: const Color(0xFF000812),
      cursorColor: const Color(0xFF000812),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(elevation: 10, backgroundColor: Colors.white),
    listTileTheme: const ListTileThemeData(
      iconColor: Color(0xFF818492),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: false,
      hintStyle: GoogleFonts.openSans(
        color: Colors.grey.withOpacity(0.5),
        fontWeight: FontWeight.w500,
        letterSpacing: 0.25,
      ),
      labelStyle: GoogleFonts.openSans(
        color: Colors.grey.withOpacity(0.5),
        fontWeight: FontWeight.w500,
        letterSpacing: 0.25,
      ),
      floatingLabelStyle: GoogleFonts.openSans(
        color: const Color(0xFF000812),
        fontWeight: FontWeight.w500,
        letterSpacing: 0.25,
      ),
      isCollapsed: false,
      // isDense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 18.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50.r),
        borderSide: const BorderSide(),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50.r),
        borderSide: BorderSide(
          color: Colors.grey.withOpacity(0.5),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50.r),
        borderSide: const BorderSide(
          color: Color(0xFF000812),
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50.r),
        borderSide: const BorderSide(
          color: Colors.redAccent,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50.r),
        borderSide: const BorderSide(
          color: Colors.redAccent,
        ),
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.all<Color>(const Color(0xFF000812)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3.r),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.disabled)) {
            return const Color(0xFF000812).withOpacity(0.7);
          } else {
            return const Color(0xFF000812);
          }
        }),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        minimumSize: MaterialStateProperty.all(Size(double.infinity, 48.h)),
        shape: MaterialStateProperty.all<OutlinedBorder>(const StadiumBorder()),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        side: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.disabled)) {
            return BorderSide(width: 1.5, color: const Color(0xFF000812).withOpacity(0.7));
          } else {
            return const BorderSide(width: 1.5, color: Color(0xFF000812));
          }
        }),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        maximumSize: MaterialStateProperty.all(Size(double.infinity, 48.h)),
        minimumSize: MaterialStateProperty.all(Size(64.w, 48.h)),
        shape: MaterialStateProperty.all<OutlinedBorder>(const StadiumBorder()),
      ),
    ),
  );
}
