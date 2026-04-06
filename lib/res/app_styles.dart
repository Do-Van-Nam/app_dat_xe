import 'package:demo_app/res/app_colors.dart';
import 'package:demo_app/res/app_fonts.dart';
import 'package:flutter/material.dart';

class AppStyles {
  static TextStyle headerBlack = AppTextFonts.interSemiBold.copyWith(
    color: AppColors.color_1C1E,
    fontSize: 30,
  );

  static TextStyle inter16Medium = AppTextFonts.interMedium.copyWith(
    color: AppColors.color_434653,
    fontSize: 16,
  );
  // ── Bold ──────────────────────────────────────────────────────
  static const TextStyle inter22Bold = TextStyle(
    fontFamily: 'Inter',
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.colorTextPrimary,
  );
  static const TextStyle inter20Bold = TextStyle(
    fontFamily: 'Inter',
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.colorTextPrimary,
  );
  static const TextStyle inter18Bold = TextStyle(
    fontFamily: 'Inter',
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.colorTextPrimary,
  );
  static const TextStyle inter16Bold = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.colorTextPrimary,
  );
  static const TextStyle inter14Bold = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.colorTextPrimary,
  );

  // ── SemiBold ──────────────────────────────────────────────────
  static const TextStyle inter18SemiBold = TextStyle(
    fontFamily: 'Inter',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.colorTextPrimary,
  );
  static const TextStyle inter16SemiBold = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.colorTextPrimary,
  );
  static const TextStyle inter14SemiBold = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.colorTextPrimary,
  );
  static const TextStyle inter13SemiBold = TextStyle(
    fontFamily: 'Inter',
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.colorTextPrimary,
  );
  static const TextStyle inter12SemiBold = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.colorTextPrimary,
  );
  static const TextStyle inter11SemiBold = TextStyle(
    fontFamily: 'Inter',
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.colorTextPrimary,
  );

  // ── Medium ────────────────────────────────────────────────────

  static const TextStyle inter14Medium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.colorTextPrimary,
  );
  static const TextStyle inter13Medium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.colorTextPrimary,
  );
  static const TextStyle inter12Medium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.colorTextPrimary,
  );

  // ── Regular ───────────────────────────────────────────────────
  static const TextStyle inter16Regular = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.colorTextPrimary,
  );
  static const TextStyle inter14Regular = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.colorTextSecondary,
  );
  static const TextStyle inter13Regular = TextStyle(
    fontFamily: 'Inter',
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.colorTextSecondary,
  );
  static const TextStyle inter12Regular = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.colorTextSecondary,
  );
  static const TextStyle inter11Regular = TextStyle(
    fontFamily: 'Inter',
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.colorTextSecondary,
  );

  static const TextStyle inter28Bold = TextStyle(
    fontFamily: 'Inter',
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.colorTextPrimary,
  );
  static const TextStyle inter24Bold = TextStyle(
    fontFamily: 'Inter',
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.colorTextPrimary,
  );

  static const TextStyle inter15Regular = TextStyle(
    fontFamily: 'Inter',
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.colorTextSecondary,
  );

  static const TextStyle inter15SemiBold = TextStyle(
    fontFamily: 'Inter',
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.colorTextPrimary,
  );

  // 15
  static const TextStyle inter15Medium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.color333333,
  );
  // ── 17 ──────────────────────────────────────────────────────────────────
  static const TextStyle inter17SemiBold = TextStyle(
    fontFamily: 'Inter',
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: AppColors.color1A56DB,
  );

  static const TextStyle inter15Bold = TextStyle(
    fontFamily: 'Inter',
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.color1A1A1A,
  );

  // ── 26 ──────────────────────────────────────────────────────────────────
  static const TextStyle inter26ExtraBold = TextStyle(
    fontFamily: 'Inter',
    fontSize: 26,
    fontWeight: FontWeight.w800,
    color: AppColors.color1A56DB,
  );
  static const TextStyle inter10Regular =
      TextStyle(fontSize: 10, fontWeight: FontWeight.w400, fontFamily: 'Inter');
  static const title = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    fontFamily: 'Inter',
    height: 1.5,
  );

  static const body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontFamily: 'Inter',
  );

  static const price = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    fontFamily: 'Inter',
    color: AppColors.primaryDark,
  );

  static const small = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontFamily: 'Inter',
  );
  static const String fontFamily = 'Inter';

  static TextStyle heading1 = const TextStyle(
    color: AppColors.textPrimary,
    fontSize: 20,
    fontFamily: fontFamily,
    fontWeight: FontWeight.w700,
    height: 1.40,
    letterSpacing: -0.50,
  );

  static TextStyle heading2 = const TextStyle(
    color: AppColors.textPrimary,
    fontSize: 18,
    fontFamily: fontFamily,
    fontWeight: FontWeight.w700,
    height: 1.56,
    letterSpacing: -0.45,
  );

  static TextStyle bodyLarge = const TextStyle(
    color: AppColors.textPrimary,
    fontSize: 16,
    fontFamily: fontFamily,
    fontWeight: FontWeight.w500,
    height: 1.50,
  );

  static TextStyle labelSmall = const TextStyle(
    color: AppColors.textSecondary,
    fontSize: 10,
    fontFamily: fontFamily,
    fontWeight: FontWeight.w700,
    height: 1.50,
    letterSpacing: 1,
  );

  static TextStyle buttonLarge = const TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontFamily: fontFamily,
    fontWeight: FontWeight.w700,
    height: 1.56,
  );
  static TextStyle headerWhite = AppTextFonts.interSemiBold.copyWith(
    color: AppColors.color_FFFF,
    fontSize: 16,
  );

  static TextStyle content = AppTextFonts.interRegular.copyWith(
    color: AppColors.color_464B,
    fontSize: 14,
  );

  static TextStyle textButtonWhite = AppTextFonts.interSemiBold.copyWith(
    color: AppColors.color_FFFF,
    fontSize: 16,
  );

  static TextStyle textButtonBlack = AppTextFonts.interSemiBold.copyWith(
    color: AppColors.color_1618,
    fontSize: 16,
  );

  static final TextStyle header = AppTextFonts.interSemiBold.copyWith(
    fontSize: 20.0,
    height: 24.0 / 20.0,
    letterSpacing: 0.0,
    fontStyle: FontStyle.normal,
  );

  static final TextStyle inter12RegularCentered = inter12Regular.copyWith();

  static const Alignment inter12RegularAlignment = Alignment.center;
  static const TextAlign inter12RegularTextAlign = TextAlign.center;

  static final TextStyle poppins12Regular =
      AppTextFonts.poppinsRegular.copyWith(
    fontSize: 12.0,
    height: 16.0 / 12.0,
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
  static const TextStyle inter10SemiBold = TextStyle(
    fontFamily: 'Inter',
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: AppColors.color666666,
  );
  static const TextStyle inter24ExtraBold = TextStyle(
    fontFamily: 'Inter', fontSize: 24, fontWeight: FontWeight.w800,
    color: AppColors.color1A56DB,
  );
  static const TextStyle inter28ExtraBold = TextStyle(
    fontFamily: 'Inter', fontSize: 28, fontWeight: FontWeight.w800,
    color: AppColors.color1A1A1A,
  );
  static const TextStyle inter36ExtraBold = TextStyle(
    fontFamily: 'Inter', fontSize: 36, fontWeight: FontWeight.w800,
    color: AppColors.color2ECC71,
  );
  static const TextStyle inter36Bold = TextStyle(
    fontFamily: 'Inter', fontSize: 36, fontWeight: FontWeight.w700,
    color: AppColors.colorTextPrimary,
  );
}
