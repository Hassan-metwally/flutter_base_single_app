import 'package:flutter/material.dart';

import '../../blocs/theme_notifier/theme_notifier.dart';
import '../../core.dart';

Color getThemeColor({Color? lightColor, Color? darkColor}) {
  switch (ThemeNotifier.instance.themeMode) {
    case ThemeMode.system:
    case ThemeMode.light:
      return lightColor ?? Colors.transparent;
    case ThemeMode.dark:
      return darkColor ?? Colors.transparent;
  }
}

T getGenericTheme<T>({required T lightColor, required T darkColor}) {
  switch (ThemeNotifier.instance.themeMode) {
    case ThemeMode.system:
    case ThemeMode.light:
      return lightColor;
    case ThemeMode.dark:
      return darkColor;
  }
}

abstract class AppTheme {
  const AppTheme();
  abstract final String name;
  abstract final ThemeMode themeMode;
  abstract final ThemeData theme;
  final String fontFamily = AppFonts.mainFont;

  /// Common Used Colors For Material Design
  ///
  abstract final Color backgroundColor;
  abstract final Color cardColor;
  abstract final Color dividerColor;
  abstract final Color disbaledColor;

  abstract final Color focusedBorderColor;
  abstract final Color enabledBorderColor;
  abstract final Color disableBorderColor;
  abstract final Color appbarBorderColor;

  abstract final Color textColor;
  abstract final Color hintColor;

  BoxShadow get boxShadow => BoxShadow(color: Colors.black.withOpacityPercent(8), blurRadius: 4);

  LinearGradient get primaryGradiant => LinearGradient(
    begin: Alignment.centerRight,
    end: Alignment.centerLeft,
    colors: [primary500, primary500.withOpacityPercent(50), primary500.withOpacityPercent(1)],
  );

  LinearGradient get disableGradient =>
      LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [black50, black100]);

  LinearGradient get greyGradient =>
      const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xff999999), Color(0xff333333)]);

  /// APP DESIGN SYSTEM COLORS
  ///
  Color get primary => primary500;
  Color get grey => primary500;
  final Color primary50 = const Color(0xffFEEDE6);
  final Color primary100 = const Color(0xffFDDACE);
  final Color primary200 = const Color(0xffFCB69C);
  final Color primary300 = const Color(0xffFA916B);
  final Color primary400 = const Color(0xffF86C3A);
  final Color primary500 = const Color(0xffD53E07);
  final Color primary600 = const Color(0xffC53907);
  final Color primary700 = const Color(0xff942B05);
  final Color primary800 = const Color(0xff631D03);
  final Color primary900 = const Color(0xff310E02);
  final Color primary950 = Colors.black;

  Color get secondary => secondary500;
  final Color secondary50 = const Color(0xffFBF5EA);
  final Color secondary100 = const Color(0xffF7EBD4);
  final Color secondary200 = const Color(0xffEED6AA);
  final Color secondary300 = const Color(0xffE6C27F);
  final Color secondary400 = const Color(0xffDDAD55);
  final Color secondary500 = const Color(0xffD9A441);
  final Color secondary600 = const Color(0xffAA7A22);
  final Color secondary700 = const Color(0xff805C19);
  final Color secondary800 = const Color(0xff553D11);
  final Color secondary900 = const Color(0xff2B1F08);

  Color get black => black900;
  final Color black50 = const Color(0xFFF2F2F2);
  final Color black100 = const Color(0xFFE8E8E8);
  final Color black200 = const Color(0xFFCFCFCF);
  final Color black300 = const Color(0xFFA3A3A3);
  final Color black400 = const Color(0xFF767676);
  final Color black500 = const Color(0xFF5C5C5C);
  final Color black600 = const Color(0xFF454545);
  final Color black700 = const Color(0xFF2F2F2F);
  final Color black800 = const Color(0xFF1C1C1C);
  final Color black900 = const Color(0xFF111111);

  Color get blue => blue600;
  final Color blue50 = const Color(0xffE6E6EA);
  final Color blue100 = const Color(0xffB1B1BF);
  final Color blue200 = const Color(0xff8C8BA0);
  final Color blue300 = const Color(0xff575575);
  final Color blue400 = const Color(0xff36355A);
  final Color blue500 = const Color(0xff040231);
  final Color blue600 = const Color(0xff04022D);
  final Color blue700 = const Color(0xff030123);
  final Color blue800 = const Color(0xff02011B);
  final Color blue900 = const Color(0xff020115);

  Color get error => red500;
  final Color red50 = const Color(0xFFFDF1F0);
  final Color red100 = const Color(0xFFF9DFDC);
  final Color red200 = const Color(0xFFF0BCB7);
  final Color red300 = const Color(0xFFE48077);
  final Color red400 = const Color(0xFFDC4538);
  final Color red500 = const Color(0xFFCC2B1C);
  final Color red600 = const Color(0xFFA82115);
  final Color red700 = const Color(0xFF7E170E);
  final Color red800 = const Color(0xFF51110B);
  final Color red900 = const Color(0xFF2B0B08);

  final Color warning50 = const Color(0xFFFDF9F0);
  final Color warning100 = const Color(0xFFFAF2DB);
  final Color warning200 = const Color(0xFFF5E2AD);
  final Color warning300 = const Color(0xFFF1CA5F);
  final Color warning400 = const Color(0xFFF3B816);
  final Color warning500 = const Color(0xFFC49208);
  final Color warning600 = const Color(0xFF967008);
  final Color warning700 = const Color(0xFF755807);
  final Color warning800 = const Color(0xFF4A3807);
  final Color warning900 = const Color(0xFF281F06);

  final Color success50 = const Color(0xFFEEF9F6);
  final Color success100 = const Color(0xFFD9F4EC);
  final Color success200 = const Color(0xFFB3E6D6);
  final Color success300 = const Color(0xFF70CDB1);
  final Color success400 = const Color(0xFF29AE86);
  final Color success500 = const Color(0xFF0C7E5C);
  final Color success600 = const Color(0xFF0A684D);
  final Color success700 = const Color(0xFF09503B);
  final Color success800 = const Color(0xFF08382A);
  final Color success900 = const Color(0xFF06231A);

  final Color white = const Color(0xFFFFFFFF);
  final Color white100 = const Color(0xFFFBFBFB);

  final Color green = const Color(0xff067B00);
  final Color greenTransparent = const Color(0x14067B00);
  final Color greenTransparent2 = const Color.fromARGB(49, 45, 218, 56);

  final Color skyBlue = const Color(0xff0066C5);
  final Color skyBlueTransparent = const Color(0xFFF6F8FF);

  final Color orange = const Color(0xffE8AF00);
  final Color orangeTransparent = const Color(0x14E8AF00);

  final Color terquoise = const Color(0xff07A49C);
  final Color terquoiseTransparent = const Color(0x1407A49C);

  final Color b14119 = const Color(0xffB14119);
  final Color b14119Transparent = const Color(0x14B14119);
}
