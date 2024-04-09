import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;

const kBackgroundColor = Color(0xFFFFD54F);
const kHomeBackgroundColor = Color(0xFFFFECB3);
const kWhiteColor = Color(0xFFFFFFFF);
const kBlackColor = Color(0xFF333333);
const kGreyColor = Color(0xFF9E9E9E);
const kGrey600Color = Color(0xFF757575);
const kGrey300Color = Color(0xFFE0E0E0);
const kGrey200Color = Color(0xFFEEEEEE);
const kRedColor = Color(0xFFF44336);
const kRed400Color = Color(0xFFEF5350);
const kRed100Color = Color(0xFFFFCDD2);
const kBlueColor = Color(0xFF2196F3);
const kBlue300Color = Color(0xFF64B5F6);
const kLightBlueColor = Color(0xFF03A9F4);
const kLightBlue800Color = Color(0xFF0277BD);
const kCyanColor = Color(0xFF00BCD4);
const kTealColor = Color(0xFF009688);
const kTeal300Color = Color(0xFF4DD0E1);
const kOrangeColor = Color(0xFFFF9800);
const kOrange300Color = Color(0xFFFFB74D);
const kYellowColor = Color(0xFFFFEB3B);
const kGreenColor = Color(0xFF4CAF50);

ThemeData customTheme() {
  return ThemeData(
    scaffoldBackgroundColor: kBackgroundColor,
    fontFamily: 'SourceHanSansJP-Regular',
    appBarTheme: const AppBarTheme(
      backgroundColor: kBackgroundColor,
      elevation: 0,
      centerTitle: false,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      titleTextStyle: TextStyle(
        color: kBlackColor,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        fontFamily: 'SourceHanSansJP-Bold',
      ),
      iconTheme: IconThemeData(color: kBlackColor),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: kBlackColor),
      bodyMedium: TextStyle(color: kBlackColor),
      bodySmall: TextStyle(color: kBlackColor),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: kBlueColor,
      elevation: 5,
      extendedTextStyle: TextStyle(
        color: kWhiteColor,
        fontWeight: FontWeight.bold,
        fontFamily: 'SourceHanSansJP-Bold',
      ),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    unselectedWidgetColor: kWhiteColor,
  );
}

const SliverGridDelegate kHome2Grid = SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 2,
);

const SliverGridDelegate kHome3Grid = SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 3,
);

List<String> kWeeks = ['月', '火', '水', '木', '金', '土', '日'];
List<String> kRepeatIntervals = ['毎日', '毎週', '毎月', '毎年'];
List<int> kAlertMinutes = [0, 10, 30, 60];

DateTime kFirstDate = DateTime.now().subtract(const Duration(days: 1095));
DateTime kLastDate = DateTime.now().add(const Duration(days: 1095));

const kDatePickerTheme = picker.DatePickerTheme(
  headerColor: kWhiteColor,
  backgroundColor: kBlueColor,
  itemStyle: TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
  doneStyle: TextStyle(
    color: kBlueColor,
    fontSize: 16,
  ),
);
