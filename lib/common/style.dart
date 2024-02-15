import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const kBackgroundColor = Color(0xFF3F51B5);
const kWhiteColor = Color(0xFFFFFFFF);
const kBlackColor = Color(0xFF333333);
const kGreyColor = Color(0xFF9E9E9E);
const kGrey2Color = Color(0xFF757575);
const kGrey3Color = Color(0xFFCCCCCC);
const kGrey4Color = Color(0xFFEEEEEE);
const kRedColor = Color(0xFFF44336);
const kBlueColor = Color(0xFF2196F3);
const kCyanColor = Color(0xFF00BCD4);
const kOrangeColor = Color(0xFFFF9800);

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
        color: kWhiteColor,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        fontFamily: 'SourceHanSansJP-Bold',
      ),
      iconTheme: IconThemeData(color: kWhiteColor),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: kWhiteColor),
      bodyMedium: TextStyle(color: kWhiteColor),
      bodySmall: TextStyle(color: kWhiteColor),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: kWhiteColor,
      elevation: 5,
      selectedItemColor: kWhiteColor,
      unselectedItemColor: kGrey2Color,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: kWhiteColor,
      elevation: 5,
      extendedTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: 'SourceHanSansJP-Bold',
      ),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    unselectedWidgetColor: kGreyColor,
  );
}

const kErrorStyle = TextStyle(
  color: kRedColor,
  fontSize: 14,
);

const SliverGridDelegate kHomeGrid = SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 2,
  childAspectRatio: 0.9,
  crossAxisSpacing: 4,
  mainAxisSpacing: 4,
);

List<Color> kPlanColors = const [
  Color(0xFF1E88E5),
  Color(0xFFE53935),
  Color(0xFF43A047),
  Color(0xFFFFB300),
];

DateTime kFirstDate = DateTime.now().subtract(const Duration(days: 1095));
DateTime kLastDate = DateTime.now().add(const Duration(days: 1095));
