import 'dart:convert';
import 'dart:io';
import 'package:demo_app/main/data/share_preference/share_preference.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
class AppLogger {
  static final AppLogger _instance = AppLogger._internal();

  factory AppLogger() {
    return _instance;
  }

  late Logger _logger;
  late Directory _logDir;
  bool _enableLogFile = false; // Mặc định tat log file

  AppLogger._internal() {
    _initLogger();
    // _loadLoggingStatus();
  }

  Future<void> _initLogger() async {
    final dir = await getApplicationDocumentsDirectory();
    _logDir = Directory('${dir.path}/logSupperApp');

    if (!await _logDir.exists()) {
      await _logDir.create(recursive: true);
    }

    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 2, // Số dòng stack trace hiển thị
        errorMethodCount: 5, // Số dòng stack trace cho error
        lineLength: 200, // Độ dài dòng log
        colors: true, // Hiển thị màu trên console
        printEmojis: true, // Thêm emoji vào log
        printTime: true, // Hiển thị thời gian log
      ),
      output: FileLogOutput(this), // Tích hợp lưu file
    );
  }

  File getLogFile() {
    String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return File('${_logDir.path}/$date.log');
  }

  Future<void> _loadLoggingStatus() async {
    _enableLogFile = await SharePreferenceUtil.enableLogFile();
  }

  Future<void> setLoggingEnabled(bool isEnabled) async {
    SharePreferenceUtil.saveLogFile(isEnabled);
    _enableLogFile = isEnabled;
  }

  void logInfo(String message) {
    if (kDebugMode) {
      print("💚️ INFO: $message");
    }
    if (_enableLogFile) {
      _logger.i(message);
    }
  }

  void logError(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      print("❤️ ERROR: $message");
    }
    if (_enableLogFile) {
      _logger.e(message, error: error, stackTrace: stackTrace);
    }
  }

  Future<void> writeToFile(String message) async {
    if (_enableLogFile) {
      final logFile = getLogFile();
      await logFile.writeAsString('$message\n', mode: FileMode.append, encoding: utf8);
    }
  }
}

class FileLogOutput extends LogOutput {
  final AppLogger appLogger;

  FileLogOutput(this.appLogger);

  @override
  void output(OutputEvent event) {
    for (var line in event.lines) {
      appLogger.writeToFile(line);
    }
  }
}

