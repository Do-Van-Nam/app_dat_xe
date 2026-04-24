// chat_event.dart
part of 'chat_bloc.dart';

abstract class ChatEvent {}

class LoadMessages extends ChatEvent {}

class SendMessage extends ChatEvent {
  final String content;
  SendMessage(this.content);
}

class NewMessageReceived extends ChatEvent {
  final ChatMessage message;
  NewMessageReceived(this.message);
}
