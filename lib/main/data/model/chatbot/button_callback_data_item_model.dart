import 'button_callback_model.dart';

class ButtonCallbackDataItem {
  final String? title;
  final String? pubUrlImage;
  final List<ButtonCallback> buttonCallBacks;

  ButtonCallbackDataItem({
    this.title,
    this.pubUrlImage,
    required this.buttonCallBacks,
  });

  factory ButtonCallbackDataItem.fromJson(Map<String, dynamic> json) {
    final buttonCallBacksJson = json['buttonCallBacks'] as List<dynamic>? ?? [];
    final buttonCallBacks = buttonCallBacksJson
        .map((e) => ButtonCallback.fromJson(e as Map<String, dynamic>))
        .toList();

    return ButtonCallbackDataItem(
      title: json['title'] as String?,
      pubUrlImage: json['pubUrlImage'] as String?,
      buttonCallBacks: buttonCallBacks,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'pubUrlImage': pubUrlImage,
      'buttonCallBacks': buttonCallBacks.map((b) => b.toJson()).toList(),
    };
  }
}
