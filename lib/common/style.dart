import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
const kBlueColor = Color(0xFF2196F3);
const kCyanColor = Color(0xFF00BCD4);
const kTealColor = Color(0xFF009688);
const kTeal300Color = Color(0xFF4DD0E1);
const kOrangeColor = Color(0xFFFF9800);
const kYellowColor = Color(0xFFFFEB3B);

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
    unselectedWidgetColor: kGreyColor,
  );
}

const SliverGridDelegate kHome2Grid = SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 2,
);

const SliverGridDelegate kHome3Grid = SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 3,
);

List<Color> kPlanColors = const [
  Color(0xFFF44336),
  Color(0xFFE91E63),
  Color(0xFF9C27B0),
  Color(0xFF673AB7),
  Color(0xFF3F51B5),
  Color(0xFF2196F3),
  Color(0xFF03A9F4),
  Color(0xFF00BCD4),
  Color(0xFF009688),
  Color(0xFF4CAF50),
  Color(0xFF8BC34A),
  Color(0xFFCDDC39),
  Color(0xFFFFEB3B),
  Color(0xFFFFC107),
  Color(0xFFFF9800),
  Color(0xFFFF5722),
  Color(0xFF795548),
  Color(0xFF9E9E9E),
  Color(0xFF607D8B),
];

DateTime kFirstDate = DateTime.now().subtract(const Duration(days: 1095));
DateTime kLastDate = DateTime.now().add(const Duration(days: 1095));
