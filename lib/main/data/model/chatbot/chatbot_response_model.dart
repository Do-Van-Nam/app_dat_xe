import 'chatbot_data_model.dart';

class ChatbotResponse {
  final bool success;
  final String? errorCode;
  final String? message;
  final ChatbotData? data;

  ChatbotResponse({required this.success, this.errorCode, this.message, this.data});

  factory ChatbotResponse.fromJson(Map<String, dynamic> json) {
    return ChatbotResponse(
      success: json['success'] as bool? ?? false,
      errorCode: json['errorCode'] as String?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? ChatbotData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'errorCode': errorCode,
      'message': message,
      'data': data?.toJson(),
    };
  }
}
