// lib/core/config/app_config.dart

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AppConfig {
  final BuildContext context;

  AppConfig(this.context);

  double get deviceWidth => MediaQuery.of(context).size.width;
  double get deviceHeight => MediaQuery.of(context).size.height;

  double w(double percentage) => deviceWidth * (percentage / 100);
  double h(double percentage) => deviceHeight * (percentage / 100);

  static double get smallSpacing => 1.h;
  static double get mediumSpacing => 2.h;
  static double get largeSpacing => 3.h;

  static double get smallPadding => 0.5.h;
  static double get mediumPadding => 1.h;
  static double get largePadding => 1.h;
  static double get screenPadding => 2.h;

  static double get smallIconSize => 1.5.h;
  static double get mediumIconSize => 3.h;
  static double get largeIconSize => 6.h;

  TextStyle? get displayLarge => Theme.of(context).textTheme.displayLarge;
  TextStyle? get displayMedium => Theme.of(context).textTheme.displayMedium;
  TextStyle? get displaySmall => Theme.of(context).textTheme.displaySmall;

  TextStyle? get headlineLarge => Theme.of(context).textTheme.headlineLarge;
  TextStyle? get headlineMedium => Theme.of(context).textTheme.headlineMedium;
  TextStyle? get headlineSmall => Theme.of(context).textTheme.headlineSmall;

  TextStyle? get titleLarge => Theme.of(context).textTheme.titleLarge;
  TextStyle? get titleMedium => Theme.of(context).textTheme.titleMedium;
  TextStyle? get titleSmall => Theme.of(context).textTheme.titleSmall;

  TextStyle? get bodyLarge => Theme.of(context).textTheme.bodyLarge;
  TextStyle? get bodyMedium => Theme.of(context).textTheme.bodyMedium;
  TextStyle? get bodySmall => Theme.of(context).textTheme.bodySmall;

  TextStyle? get labelLarge => Theme.of(context).textTheme.labelLarge;
  TextStyle? get labelMedium => Theme.of(context).textTheme.labelMedium;
  TextStyle? get labelSmall => Theme.of(context).textTheme.labelSmall;

  static double get appBarHeight => 7.h;
  static double get tabSwitcherHeight => 6.h;
  static double get avatarSize => 5.h;
  static double get fabSize => 7.h;
  static double get cardElevation => 0.2.h;

  static double get smallRadius => 1.h;
  static double get mediumRadius => 1.5.h;
  static double get largeRadius => 2.h;
  static double get pillRadius => 5.h;

  static double get listItemHeight => 8.h;
  static double get chatListItemHeight => 9.h;
}
