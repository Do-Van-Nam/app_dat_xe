import 'button_callback_data_item_model.dart';

class ChatbotData {
  final String id;
  final String buttonName;
  final String callbackData;
  final List<ButtonCallbackDataItem> buttonCallbackDataList;
  final String? linkAddress;
  final String? imageName;
  final String descriptionButton;

  // Hai trường mới - KHÔNG final để có thể chỉnh sửa sau
  bool isBot;
  DateTime? datetime;

  // Các trường optional mới
  final String? answer;
  final List<String>? suggestionQuestion;

  ChatbotData({
    required this.id,
    required this.buttonName,
    required this.callbackData,
    required this.buttonCallbackDataList,
    this.linkAddress,
    this.imageName,
    required this.descriptionButton,
    this.isBot = true, // Default là true vì đây là response từ bot
    this.datetime, // Sẽ set tự động trong fromJson
    this.answer,
    this.suggestionQuestion,
  });

  factory ChatbotData.fromJson(Map<String, dynamic> json) {
    final buttonCallbackDataListJson =
        json['buttonCallbackDataList'] as List<dynamic>? ?? [];
    final buttonCallbackDataList = buttonCallbackDataListJson
        .map((e) => ButtonCallbackDataItem.fromJson(e as Map<String, dynamic>))
        .toList();

    final suggestionQuestionJson = json['suggestionQuestion'] as List<dynamic>?;

    return ChatbotData(
      id: json['id'] as String? ?? '',
      buttonName: json['buttonName'] as String? ?? '',
      callbackData: json['callbackData'] as String? ?? '',
      buttonCallbackDataList: buttonCallbackDataList,
      linkAddress: json['linkAddress'] as String?,
      imageName: json['imageName'] as String?,
      descriptionButton: json['descriptionButton'] as String? ?? '',
      // Tự động set hai trường mới
      isBot: json['isBot'] as bool? ?? true, // Vì đây là response từ server/bot
      datetime: json['datetime'] != null
          ? DateTime.parse(json['datetime'])
          : DateTime.now(), // Thời gian hiện tại khi parse
      answer: json['answer'] as String?,
      suggestionQuestion: suggestionQuestionJson
          ?.map((e) => e as String)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'buttonName': buttonName,
      'callbackData': callbackData,
      'buttonCallbackDataList': buttonCallbackDataList
          .map((item) => item.toJson())
          .toList(),
      'linkAddress': linkAddress,
      'imageName': imageName,
      'descriptionButton': descriptionButton,
      // Hai trường mới - có thể thêm vào JSON nếu bạn cần export
      'isBot': isBot,
      'datetime': datetime?.toIso8601String(),
      // Các trường optional mới
      'answer': answer,
      'suggestionQuestion': suggestionQuestion,
    };
  }

  // Phương thức helper để chỉnh sửa sau này (nếu cần)
  void updateIsBot(bool value) {
    isBot = value;
  }

  void updateDateTime(DateTime newTime) {
    datetime = newTime;
  }
}
