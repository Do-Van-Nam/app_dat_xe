import 'dart:async';
import 'dart:developer' as developer;

import 'package:demo_app/main/data/api/api_end_point.dart';
import 'package:demo_app/main/data/model/chatbot/chatbot_data_model.dart';
import 'package:demo_app/main/data/repository/chatbot_repository.dart';
import 'package:demo_app/main/data/database/chat_db_helper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatState.initial()) {
    // Gửi tin nhắn
    on<SendMessageEvent>((event, emit) async {
      if (state.isTyping) return;
      var userMessage = ChatbotData(
        id: "user",
        buttonName: '',
        callbackData: '',
        buttonCallbackDataList: [],
        descriptionButton: event.question,
        datetime: DateTime.now(),
      );
      userMessage.updateIsBot(false);

      emit(
        state.copyWith(
          messages: event.userMessage
              ? [...state.messages, userMessage]
              : [...state.messages],
          isTyping: true,
        ),
      );
      await ChatBotDbHelper.instance.saveMessage(userMessage);
      final repo = ChatBotRepository();
      try {
        print("goi api");
        final botReply = await repo.getReply(
          buttonCallback: event.buttonCallback,
          wsCode: event.wsCode,
          question: event.question,
        );
        final botMessage = botReply.data!;

        emit(
          state.copyWith(
            messages: [...state.messages, botMessage],
            isTyping: false,
          ),
        );
        await ChatBotDbHelper.instance.saveMessage(botMessage);
        print("response");
        print(botReply);
        // Sử dụng menuResponse.data!.descriptionButton, menuResponse.data!.buttonCallbackDataList...
      } catch (e) {
        // Hiển thị lỗi cho user
        emit(state.copyWith(isTyping: false));
        print('Lỗi lấy menu: $e');
      }
    });
    on<SendMessageFromInputEvent>((event, emit) async {
      if (state.isTyping) return;
      var userMessage = ChatbotData(
        id: "user",
        buttonName: '',
        callbackData: '',
        buttonCallbackDataList: [],
        descriptionButton: event.question,
        datetime: DateTime.now(),
      );
      userMessage.updateIsBot(false);
      emit(
        state.copyWith(
          messages: [...state.messages, userMessage],
          isTyping: true,
        ),
      );

      await ChatBotDbHelper.instance.saveMessage(userMessage);
      final repo = ChatBotRepository();
      try {
        print("goi api");
        final botReply = await repo.getReply(
          buttonCallback: "",
          wsCode: "wsFaqQuery",
          question: event.question,
        );
        final botMessage = botReply.data!;

        emit(
          state.copyWith(
            messages: [...state.messages, botMessage],
            //isTyping: false,
          ),
        );
        await ChatBotDbHelper.instance.saveMessage(botMessage);
        final botReply2 = await repo.getReply(
          buttonCallback: "",
          wsCode: "wsSuggestMenu",
          question: event.question,
        );
        final botMessage2 = botReply2.data!;
        emit(
          state.copyWith(
            messages: [...state.messages, botMessage2],
            isTyping: false,
          ),
        );
        await ChatBotDbHelper.instance.saveMessage(botMessage2);
        print("response");
        print(botReply);
        // Sử dụng menuResponse.data!.descriptionButton, menuResponse.data!.buttonCallbackDataList...
      } catch (e) {
        // Hiển thị lỗi cho user
        emit(state.copyWith(isTyping: false));
        print('Lỗi lấy menu: $e');
      }
    });

    // Chọn ngôn ngữ
    on<ChangeLanguageEvent>((event, emit) {
      emit(state.copyWith(selectedLanguage: event.language));
    });

    on<ToggleMenuEvent>((event, emit) {
      emit(state.copyWith(isOpenMenu: !state.isOpenMenu));
    });
    on<ResetChatEvent>((event, emit) async {
      await ChatBotDbHelper.instance.clearHistory();
      emit(state.copyWith(messages: []));
      event.completer?.complete();
    });
    on<InitChatEvent>((event, emit) async {
      if (event.initialMessage == "continue") {
        final history = await ChatBotDbHelper.instance.loadMessages();
        print("history");
        print(history);
        if (history.isNotEmpty) {
          emit(state.copyWith(messages: history));
          return;
        }
      }
      await ChatBotDbHelper.instance.clearHistory();
      add(
        SendMessageEvent(
          event.initialMessage,
          "list_language",
          "wsGetMenu",
        ),
      );
    });
  }
}
