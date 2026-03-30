import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:demo_app/main/data/model/chatbot/chatbot_data_model.dart'; // Model ChatbotData của bạn

part 'app_database.g.dart';
// chay de gen app_database.g.dart
// fvm dart run build_runner build --delete-conflicting-outputs
// Table định nghĩa
class ChatMessages extends Table {
  IntColumn get localId => integer().autoIncrement()();
  TextColumn get jsonData => text()();
  TextColumn get timestamp => text()(); // ISO8601 string
}

@DriftDatabase(tables: [ChatMessages])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Migration nếu sau này thay đổi schema
  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (migrator, from, to) async {
          // Nếu sau này thêm table/column thì viết migration ở đây
        },
      );

  // Hàm tiện ích để convert ChatbotData ↔ drift row
  Future<void> saveMessage(ChatbotData message) async {
    final row = ChatMessagesCompanion(
      jsonData: Value(jsonEncode(message.toJson())),
      timestamp: Value((message.datetime ?? DateTime.now()).toIso8601String()),
    );

    await into(chatMessages).insertOnConflictUpdate(row);
  }

  Future<List<ChatbotData>> loadMessages() async {
    final rows = await select(chatMessages).get();

    return rows.map((row) {
      final jsonMap = jsonDecode(row.jsonData) as Map<String, dynamic>;
      return ChatbotData.fromJson(jsonMap);
    }).toList();
  }

  Future<void> clearHistory() async {
    await delete(chatMessages).go();
  }
}

// Hàm mở connection (native sqlite)
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'chatbot_history.db'));
    return NativeDatabase.createInBackground(file);
  });
}