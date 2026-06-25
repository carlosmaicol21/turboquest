import 'package:flutter/material.dart';

class ResponsiveUtils {
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 1200;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1200;
  }

  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double getResponsiveFontSize(BuildContext context, {
    required double mobileSize,
    double? tabletSize,
    double? desktopSize,
  }) {
    if (isDesktop(context)) {
      return desktopSize ?? tabletSize ?? mobileSize * 1.2;
    } else if (isTablet(context)) {
      return tabletSize ?? mobileSize * 1.1;
    }
    return mobileSize;
  }

  static double getResponsivePadding(BuildContext context) {
    if (isDesktop(context)) {
      return 48;
    } else if (isTablet(context)) {
      return 32;
    }
    return 16;
  }

  static double getResponsiveSpacing(BuildContext context) {
    if (isDesktop(context)) {
      return 32;
    } else if (isTablet(context)) {
      return 24;
    }
    return 16;
  }

  static int getCrossAxisCount(BuildContext context) {
    if (isDesktop(context)) {
      return 3;
    } else if (isTablet(context)) {
      return 2;
    }
    return 1;
  }

  static double getImageHeight(BuildContext context) {
    final screenHeight = getScreenHeight(context);
    if (isDesktop(context)) {
      return screenHeight * 0.4;
    } else if (isTablet(context)) {
      return screenHeight * 0.35;
    }
    return screenHeight * 0.3;
  }
}
