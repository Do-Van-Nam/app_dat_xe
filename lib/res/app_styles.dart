import 'package:demo_app/res/app_colors.dart';
import 'package:demo_app/res/app_fonts.dart';
import 'package:flutter/material.dart';

class AppStyles {
  static TextStyle headerBlack = AppTextFonts.poppinsSemiBold.copyWith(
    color: AppColors.color_1618,
    fontSize: 16,
  );

  static TextStyle headerWhite = AppTextFonts.poppinsSemiBold.copyWith(
    color: AppColors.color_FFFF,
    fontSize: 16,
  );

  static TextStyle title = AppTextFonts.poppinsSemiBold.copyWith(
    color: AppColors.color_1618,
    fontSize: 18,
  );

  static TextStyle content = AppTextFonts.poppinsRegular.copyWith(
    color: AppColors.color_464B,
    fontSize: 14,
  );

  static TextStyle textButtonWhite = AppTextFonts.poppinsSemiBold.copyWith(
    color: AppColors.color_FFFF,
    fontSize: 16,
  );

  static TextStyle textButtonBlack = AppTextFonts.poppinsSemiBold.copyWith(
    color: AppColors.color_1618,
    fontSize: 16,
  );

  static final TextStyle poppins12Regular = AppTextFonts.poppinsRegular
      .copyWith(
        fontSize: 12.0,
        height: 16.0 / 12.0,
        letterSpacing: 0.0,
        fontStyle: FontStyle.normal,
      );

  static final TextStyle header = AppTextFonts.poppinsSemiBold.copyWith(
    fontSize: 20.0,
    height: 24.0 / 20.0,
    letterSpacing: 0.0,
    fontStyle: FontStyle.normal,
  );

  static final TextStyle poppins14Medium = AppTextFonts.poppinsMedium.copyWith(
    fontSize: 14.0,
    // height: 24.0 / 14.0,
    letterSpacing: 0.0,
    fontStyle: FontStyle.normal,
  );
  static final TextStyle poppins12RegularCentered = poppins12Regular.copyWith();

  static const Alignment poppins12RegularAlignment = Alignment.center;
  static const TextAlign poppins12RegularTextAlign = TextAlign.center;
}
