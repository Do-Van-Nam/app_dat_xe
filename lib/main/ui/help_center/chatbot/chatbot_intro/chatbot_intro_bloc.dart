import 'package:flutter_bloc/flutter_bloc.dart';

part 'chatbot_intro_event.dart';
part 'chatbot_intro_state.dart';

class ChatbotIntroBloc extends Bloc<ChatbotIntroEvent, ChatbotIntroState> {
  ChatbotIntroBloc() : super(ChatbotIntroInitial()) {

    on<StartChatEvent>((event, emit) async {
      emit(ChatbotIntroLoading());
      // Giả lập gọi API (thay bằng API thật sau)
     // await Future.delayed(const Duration(seconds: 1));
      emit(ChatbotIntroSuccess(startNew: true));
    });

    on<ContinueChatEvent>((event, emit) async {
      emit(ChatbotIntroLoading());
      // Giả lập gọi API (kiểm tra session cũ)
     // await Future.delayed(const Duration(seconds: 1));
      emit(ChatbotIntroSuccess(startNew: false));
    });
  }
}