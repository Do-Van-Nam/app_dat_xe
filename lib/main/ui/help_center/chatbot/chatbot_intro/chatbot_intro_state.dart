// chatbot_intro_state.dart
part of 'chatbot_intro_bloc.dart';

abstract class ChatbotIntroState {}

class ChatbotIntroInitial extends ChatbotIntroState {}

class ChatbotIntroLoading extends ChatbotIntroState {}

class ChatbotIntroSuccess extends ChatbotIntroState {
  final bool startNew;
  ChatbotIntroSuccess({required this.startNew});
}

class ChatbotIntroError extends ChatbotIntroState {
  final String message;
  ChatbotIntroError(this.message);
}
