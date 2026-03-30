import 'package:flutter/material.dart';

class AppTextFonts {
  static const TextStyle _poppins = TextStyle(fontFamily: 'Poppins');

  static final TextStyle poppinsThin = _poppins.copyWith(
    fontWeight: FontWeight.w100,
  );
  static final TextStyle poppinsExtraLight = _poppins.copyWith(
    fontWeight: FontWeight.w200,
  );
  static final TextStyle poppinsLight = _poppins.copyWith(
    fontWeight: FontWeight.w300,
  );
  static final TextStyle poppinsRegular = _poppins.copyWith(
    fontWeight: FontWeight.w400,
  );
  static final TextStyle poppinsMedium = _poppins.copyWith(
    fontWeight: FontWeight.w500,
  );
  static final TextStyle poppinsSemiBold = _poppins.copyWith(
    fontWeight: FontWeight.w600,
  );
  static final TextStyle poppinsBold = _poppins.copyWith(
    fontWeight: FontWeight.w700,
  );
  static final TextStyle poppinsExtraBold = _poppins.copyWith(
    fontWeight: FontWeight.w800,
  );
  static final TextStyle poppinsBlack = _poppins.copyWith(
    fontWeight: FontWeight.w900,
  );
}
