// chat_state.dart
part of 'chat_bloc.dart';

class ChatState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final UniqueError? error;
  final String? userId;

  ChatState({
    this.messages = const [],
    this.isLoading = false,
    this.error,
    this.userId,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    UniqueError? error,
    String? userId,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      userId: userId ?? this.userId,
    );
  }
}
