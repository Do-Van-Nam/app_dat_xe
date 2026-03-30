// chat_event.dart
part of 'chat_bloc.dart';

abstract class ChatEvent {}

class SendMessageEvent extends ChatEvent {
  final String question;
  final String buttonCallback;
  final String wsCode;
  final bool userMessage;
  SendMessageEvent(
    this.question,
    this.buttonCallback,
    this.wsCode, {
    this.userMessage = true,
  });
}

class SendMessageFromInputEvent extends ChatEvent {
  final String question;
  SendMessageFromInputEvent(this.question);
}

class ChangeLanguageEvent extends ChatEvent {
  final String language; // "km" hoặc "en"
  ChangeLanguageEvent(this.language);
}

class ToggleMenuEvent extends ChatEvent {}

class ResetChatEvent extends ChatEvent {
  final Completer? completer;
  ResetChatEvent({this.completer});
}

class InitChatEvent extends ChatEvent {
  final String initialMessage;
  InitChatEvent(this.initialMessage);
}
