// chat_state.dart
part of 'chat_bloc.dart';

class ChatState {
  final List<ChatbotData> messages;
  final bool isTyping;
  final bool isOpenMenu;
  final String selectedLanguage; // "km" hoặc "en"

  ChatState({
    required this.messages,
    required this.isTyping,
    required this.selectedLanguage,
    required this.isOpenMenu,
  });

  factory ChatState.initial() => ChatState(
    messages: [
      
    ],
    isTyping: false,
    selectedLanguage: "en",
    isOpenMenu: false,
  );

  ChatState copyWith({
    List<ChatbotData>? messages,
    bool? isTyping,
    String? selectedLanguage,
    bool? isOpenMenu,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      isOpenMenu: isOpenMenu ?? this.isOpenMenu,
    );
  }
}
