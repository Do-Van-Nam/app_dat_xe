// chatbot_intro_event.dart
part of 'chatbot_intro_bloc.dart';

abstract class ChatbotIntroEvent {}

class StartChatEvent extends ChatbotIntroEvent {}
class ContinueChatEvent extends ChatbotIntroEvent {}