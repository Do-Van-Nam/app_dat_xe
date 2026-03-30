import 'package:demo_app/res/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// System UI Overlay Style cho status bar transparent với icon và text trắng
const SystemUiOverlayStyle appSystemUiOverlayStyle = SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  statusBarIconBrightness: Brightness.light, // icon trắng
  statusBarBrightness: Brightness.dark, // iOS
);

ThemeData themeData = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.colorMain),
  useMaterial3: true,
  scaffoldBackgroundColor: AppColors.colorMain,
  appBarTheme: const AppBarTheme(systemOverlayStyle: appSystemUiOverlayStyle),
);

class AppTheme {
  // ==================== LIGHT THEME ====================
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,                    // Bắt buộc để dùng Material 3
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,              // Màu chủ đạo (thay bằng màu brand của bạn)
      brightness: Brightness.light,
    ),
    // Typography (font chữ)
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(fontSize: 16),
      bodyMedium: TextStyle(fontSize: 14),
    ),
  );

  // ==================== DARK THEME ====================
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(fontSize: 16),
      bodyMedium: TextStyle(fontSize: 14),
    ),
  );
}