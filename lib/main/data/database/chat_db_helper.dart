import 'package:demo_app/main/data/database/app_database.dart';
import 'package:demo_app/main/data/model/chatbot/chatbot_data_model.dart';

class ChatBotDbHelper {
  static final ChatBotDbHelper instance = ChatBotDbHelper._init();
  static AppDatabase? _db;

  ChatBotDbHelper._init();

  Future<AppDatabase> get database async {
    _db ??= AppDatabase();
    return _db!;
  }

  // --- HÀM LƯU TIN NHẮN ---
  Future<void> saveMessage(ChatbotData message) async {
    final db = await database;
    await db.saveMessage(message);
  }

  // --- HÀM LẤY TOÀN BỘ LỊCH SỬ ---
  Future<List<ChatbotData>> loadMessages() async {
    final db = await database;
    return await db.loadMessages();
  }

  // --- HÀM XÓA LỊCH SỬ ---
  Future<void> clearHistory() async {
    final db = await database;
    await db.clearHistory();
  }

  // Đóng database khi không dùng nữa (optional, gọi khi app terminate)
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}